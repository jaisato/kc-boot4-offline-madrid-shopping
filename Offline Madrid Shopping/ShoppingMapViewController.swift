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
import CoreData

class ShoppingMapViewController: UIViewController {

    private let TITLE = "Madrid Shopping Map"

    let CELL_ID = "ShopCell"
    let ANNOTATION_ID = "AnnotationId"

    private let GO_TO_SHOP_DETAIL = "GoToShopDetail"
    
    var language: Language!
    
    var shops: [Shop]?
    
    var shopDetail: Shop!
    
    var coreDataManager: CoreDataManager!
    
    var context: NSManagedObjectContext!
    
    var _fetchedResultsController: NSFetchedResultsController<Shop>? = nil
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TITLE

        self.setTableViewDelegates()
        self.setContext(manager: self.coreDataManager)
        
        self.setMapViewHeight()
        self.registerCellView()
        
        self.configureLocationManager()
        self.initializeMapView()
        
        print("ShoppingMapViewController viewDidLoad: shops = \( shops?.count ?? 0)")
    }
    
    // MARK: - UIViewController config funcs
    
    func registerCellView() {
        self.tableView.register(ShopCell.self, forCellReuseIdentifier: CELL_ID)
        self.tableView.register(UINib(nibName: "ShopCell", bundle: nil), forCellReuseIdentifier: CELL_ID)
    }
    
    func setMapViewHeight() {
        self.mapViewHeight.constant = (view.bounds.height - self.navigationController!.navigationBar.frame.size.height) / 2
    }
    
    // MARK: - Segues

    func goToShopDetail(shop: Shop) {
        print("Go to shop detail")
        self.shopDetail = shop
        performSegue(withIdentifier: self.GO_TO_SHOP_DETAIL, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
            case self.GO_TO_SHOP_DETAIL:
                let shopDetailVC = segue.destination as! ShopDetailViewController
                shopDetailVC.language = self.language
                shopDetailVC.shop = self.shopDetail
                break
            default:
                break
        }
    }
}

