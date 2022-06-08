//
//  NewMapViewController.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/25.
//

import MapKit
import RxRelay
import RxSwift
import UIKit

final class MapViewController: UIViewController {
    static let id = "MapViewController"
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.delegate = self
        mapView.register(PriceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PriceAnnotationView.identifier)
        return mapView
    }()
    
    private let viewModel: MapViewModel
    private let disposeBag = DisposeBag()
    private let didSelectAnnotation = PublishRelay<Lodging>()
    
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

        viewModel.updatePin
            .map { $0.map { PriceAnnotation(coordenate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), lodging: $0) } }
            .bind(onNext: mapView.addAnnotations)
            .disposed(by: disposeBag)
        
        didSelectAnnotation
            .bind(to: viewModel.selectedAnnotation)
            .disposed(by: disposeBag)
        
//        viewModel.presentDetail
//            .bind(onNext: presentDetailViewController)
//            .disposed(by: disposeBag)
        
        viewModel.presentDetail
            .bind(onNext: { _ in
                for item in self.mapView.selectedAnnotations {
                    self.mapView.deselectAnnotation(item, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
    }
    
    private func layout() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func presentDetailViewController(id: Int) {
        for item in self.mapView.selectedAnnotations {
            self.mapView.deselectAnnotation(item, animated: false)
        }
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
        priceAnnotationView.setPrice(price: "₩\(annotation.lodging.price)")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let priceAnnotation = view.annotation as? PriceAnnotation else { return }
        didSelectAnnotation.accept(priceAnnotation.lodging)
    }
}
