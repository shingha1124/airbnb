//
//  NewMapViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import MapKit
import RxSwift
import UIKit

final class MapViewController: UIViewController {
    
    enum Contants {
        static let spacing = 16.0
        static let cellSize = CGSize(width: UIScreen.main.bounds.width - 60, height: 120)
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.delegate = self
        mapView.register(PriceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PriceAnnotationView.identifier)
        return mapView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Contants.cellSize
        layout.minimumLineSpacing = Contants.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 50)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MapCollectionCell.self, forCellWithReuseIdentifier: MapCollectionCell.identifier)
        return collectionView
    }()
    
    private let viewModel: MapViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.updateRegion
            .map { ($0, true) }
            .bind(onNext: mapView.setRegion)
            .disposed(by: disposeBag)
        
        viewModel.updateLodging
            .bind(to: collectionView.rx.items(cellIdentifier: MapCollectionCell.identifier, cellType: MapCollectionCell.self)) { _, lodging, cell in
                cell.setData(with: lodging)
            }
            .disposed(by: disposeBag)
        
        viewModel.updatePin
            .map { $0.map { PriceAnnotation(coordenate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), price: $0.price) } }
            .bind(onNext: mapView.addAnnotations)
            .disposed(by: disposeBag)
        
        collectionView.rx.willEndDragging
            .bind(onNext: customPaging)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.selectedCell)
            .disposed(by: disposeBag)
        
        viewModel.presentDetail
            .bind(onNext: presentDetailViewController)
            .disposed(by: disposeBag)
    }

    private func attribute() {
    }
    
    private func layout() {
        view.addSubview(mapView)
        view.addSubview(collectionView)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
    }
    
    private func presentDetailViewController(id: Int) {
        lazy var detailViewController = DetailViewController(viewModel: DetailViewModel(id: id))
        detailViewController.modalPresentationStyle = .fullScreen
        present(detailViewController, animated: true, completion: nil)
    }
    
    private func customPaging(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = Contants.cellSize.width + Contants.spacing
        let offset = targetContentOffset.pointee
        let index = (offset.x + collectionView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        if collectionView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        let offsetX = roundedIndex * cellWidthIncludingSpacing - collectionView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: offsetX, y: 0)
        collectionView.layoutIfNeeded()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PriceAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PriceAnnotationView.identifier)
        if annotationView == nil {
            let priceAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: PriceAnnotationView.identifier)
            annotationView = priceAnnotationView
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        guard let priceAnnotationView = annotationView as? PriceAnnotationView else { return nil }
        priceAnnotationView.setPrice(price: "₩\(annotation.price)")
        return annotationView
    }
}
