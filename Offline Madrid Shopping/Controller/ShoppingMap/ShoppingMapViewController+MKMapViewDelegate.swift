//
//  ShoppingMapViewController+MKMapViewDelegate.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 6/8/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation
import MapKit

extension ShoppingMapViewController: MKMapViewDelegate {
    
    // MARK: - Shop Map funcs
    
    func initializeMapView() {
        mapView.delegate = self
        
        let regionRadius: CLLocationDistance = 200
        
        let madridLocation = CLLocation(latitude: 40.416775, longitude: -3.703790)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            madridLocation.coordinate,
            regionRadius,
            regionRadius
        )
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        self.addShopAnnotations()
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func addShopAnnotations() {
        print("Adding annotations")
        for shop in fetchedResultsController.fetchedObjects! as [Shop] {
            if let lat = shop.location?.latitude, let lon = shop.location?.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let annotation = ShopMapPin(coordinate: coordinate, shop: shop)
                self.mapView.addAnnotation(annotation)
            }
        }
    }

    func configureAnnotationView(_ annotationView: MKPinAnnotationView) {
        guard let annotation = annotationView.annotation as? ShopMapPin else { return }
        
        annotationView.pinTintColor = .blue
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = annotation.logo()
        annotationView.leftCalloutAccessoryView = imageView
    }
    
    
    // MARK: - Map Kit MapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ShopMapPin else { return nil }
        
        var annotationView: MKPinAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ANNOTATION_ID) {
            annotationView = dequeuedAnnotationView as? MKPinAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: ANNOTATION_ID)
        }
        
        if let annotationView = annotationView {
            configureAnnotationView(annotationView)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? ShopMapPin else { return }
        
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let _ = view.subviews.map { $0.removeFromSuperview() }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? ShopMapPin else { return }
        
        if control == view.rightCalloutAccessoryView {
            goToShopDetail(shop: annotation.shop)
        }
    }
}
