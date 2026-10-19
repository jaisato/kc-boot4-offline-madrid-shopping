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
        self.locationManager?.delegate = self
        // Only the permission. The map view (showsUserLocation in the
        // storyboard) tracks and draws the user's position on its own; this
        // also started the location manager's own updates, which nothing ever
        // read (there is no locationManager(_:didUpdateLocations:)) and which
        // kept the GPS running for as long as the map was alive.
        self.locationManager?.requestWhenInUseAuthorization()
    }
}
