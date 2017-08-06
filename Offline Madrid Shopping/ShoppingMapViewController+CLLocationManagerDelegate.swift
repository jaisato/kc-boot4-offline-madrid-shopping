//
//  ShoppingMapViewController+CLLocationManagerDelegate.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 6/8/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation
import CoreLocation

extension ShoppingMapViewController: CLLocationManagerDelegate {
    
    // MARK: - Location Manager funcs
    
    func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.delegate = self
        self.locationManager?.startUpdatingLocation()
    }
}
