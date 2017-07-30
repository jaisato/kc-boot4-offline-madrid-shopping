//
//  ShoppingMapViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ShoppingMapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    private let TITLE = "Madrid Shopping Map"
    
    private let CELL_ID = "ShopCell"
    
    var shops: [Shop]?
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TITLE
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(ShopCell.self, forCellReuseIdentifier: CELL_ID)
        
        self.tableView.register(UINib(nibName: "ShopCell", bundle: nil), forCellReuseIdentifier: CELL_ID)
        
        configureLocationManager()
        initializeMapView()
        
        print("ShoppingMapViewController viewDidLoad: shops = \( shops?.count ?? 0)")
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    private func initializeMapView() {
        mapView.delegate = self
        
        let madridLocation = CLLocation(latitude: 40.416775, longitude: -3.703790)
        // self.mapView.setCenter(madridLocation.coordinate, animated: true)
        
        let region = MKCoordinateRegion(center: madridLocation.coordinate, span: MKCoordinateSpanMake(0.2, 0.2))
        self.mapView.setRegion(region, animated: true)
    }
    
    // MARK: - UITableView Data source

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shops?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shopCell: ShopCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? ShopCell {
            shopCell = cell
        } else {
            shopCell = ShopCell(style: .default, reuseIdentifier: CELL_ID)
        }
        
        if let shop: Shop = shops?[indexPath.row] {
            shopCell.loadData(shop: shop)
        }
        
        return shopCell
    }
}

