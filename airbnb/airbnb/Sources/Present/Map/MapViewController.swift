//
//  MapViewController.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/23.
//

import MapKit
import RxAppState
import RxSwift

final class MapViewController: UIViewController {
    
    private lazy var mapView = MapView(frame: view.frame)
    private let mapCollectionDataSource = MapCollectionDataSource()
    private let mapCollectionFlow = MapCollectionDelegate()
    private let mkMapViewManager = MapDelegate()
    private let viewModel: MapViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: MapViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        rx.viewWillAppear
            .compactMap { _ in }
            .bind(to: viewModel.action().loadPinData)
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .compactMap { _ in }
            .bind(to: viewModel.action().loadCollectionData)
            .disposed(by: disposeBag)
        
        mapCollectionFlow.selectedCellRelay
            .bind(to: viewModel.action().collectionSelected)
            .disposed(by: disposeBag)
        
        viewModel.state().loadedPin
            .map { $0.map { PriceAnnotation(coordenate: CLLocationCoordinate2D(latitude: $0.x, longitude: $0.y)) } }
            .bind(onNext: mapView.mkMapView.addAnnotations)
            .disposed(by: disposeBag)

        viewModel.state().loadedCollectionData
            .bind(to: mapView.collectionView.rx.items(cellIdentifier: MapCollectionCell.identifier, cellType: MapCollectionCell.self)) { index, model, cell in print("\(index) \(model) \(cell)") }
            .disposed(by: disposeBag)
        
        viewModel.state().collectionSelectedData
            .bind(onNext: presentDetailViewController)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view = mapView
        mapView.collectionView.delegate = mapCollectionFlow
        mapView.mkMapView.delegate = mkMapViewManager
    }
    
    private func layout() {}
    
    private func presentDetailViewController(selectedData: MapDTO) {
        let detailViewContller = DetailViewController()
        detailViewContller.modalPresentationStyle = .fullScreen
        present(detailViewContller, animated: true, completion: nil)
    }
}
