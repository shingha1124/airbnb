//
//  MapDelegate.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/24.
//

import MapKit

final class MapDelegate: NSObject {
}
extension MapDelegate: MKMapViewDelegate {
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
        print("map delegate called")
        guard let priceAnnotationView = annotationView as? PriceAnnotationView else { return nil }
        priceAnnotationView.setPrice(price: "₩3,000")
        return annotationView
    }
}
