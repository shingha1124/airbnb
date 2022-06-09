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

final class MapViewController: BaseViewController, View {
    
    static let id = "MapViewController"
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.delegate = self
        mapView.register(PriceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PriceAnnotationView.identifier)
        return mapView
    }()
    
    var disposeBag = DisposeBag()
    private let didSelectAnnotation = PublishRelay<Lodging>()
    
    func bind(to viewModel: MapViewModel) {
        rx.viewDidLoad
            .bind(to: viewModel.action.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.state.updateRegion
            .map { ($0, true) }
            .bind(onNext: mapView.setRegion)
            .disposed(by: disposeBag)

        viewModel.state.updatePin
            .map { $0.map { PriceAnnotation(coordenate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), lodging: $0) } }
            .bind(onNext: mapView.addAnnotations)
            .disposed(by: disposeBag)
        
        didSelectAnnotation
            .bind(to: viewModel.action.selectedAnnotation)
            .disposed(by: disposeBag)
        
        viewModel.state.presentDetail
            .bind(onNext: { _ in
                for item in self.mapView.selectedAnnotations {
                    self.mapView.deselectAnnotation(item, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func attribute() {
    }
    
    override func layout() {
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
