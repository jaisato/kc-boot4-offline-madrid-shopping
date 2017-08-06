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

class ShoppingMapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    private let TITLE = "Madrid Shopping Map"

    private let CELL_ID = "ShopCell"
    private let ANNOTATION_ID = "AnnotationId"

    private let GO_TO_SHOP_DETAIL = "GoToShopDetail"
    
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
    
        mapViewHeight.constant = view.bounds.height / 2
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.context = self.getContext(manager: self.coreDataManager)
        
        self.tableView.register(ShopCell.self, forCellReuseIdentifier: CELL_ID)
        
        self.tableView.register(UINib(nibName: "ShopCell", bundle: nil), forCellReuseIdentifier: CELL_ID)
        
        configureLocationManager()
        initializeMapView()
        
        print("ShoppingMapViewController viewDidLoad: shops = \( shops?.count ?? 0)")
    }
    
    func getContext(manager: CoreDataManager) -> NSManagedObjectContext {
        let container = manager.persistentContainer(dbName: manager.DB_NAME)
        return container.viewContext
    }
    
    var fetchedResultsController: NSFetchedResultsController<Shop> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        _fetchedResultsController = NSFetchedResultsController(
            fetchRequest: Shop.fetchRequestOrderedByName(),
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: "Master"
        )
        
        _fetchedResultsController?.delegate = self
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    private func initializeMapView() {
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
    
    private func addShopAnnotations() {
        print("Adding annotations")
        for shop in fetchedResultsController.fetchedObjects! as [Shop] {
            if let lat = shop.location?.latitude, let lon = shop.location?.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let annotation = ShopMapPin(coordinate: coordinate, shop: shop)
                self.mapView.addAnnotation(annotation)
            
                print("Annotation added: lat \(coordinate.latitude), lon \(coordinate.longitude)")
            }
        }
    }
    
    // MARK: TableView Data Source
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ShopCell
        
        let shop = self.fetchedResultsController.object(at: indexPath)
        cell.loadData(shop: shop)
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shop = self.fetchedResultsController.object(at: indexPath)
        goToShopDetail(shop: shop)
    }
    
    // MARK: - Map
    
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
    
    private func configureAnnotationView(_ annotationView: MKPinAnnotationView) {
        guard let annotation = annotationView.annotation as? ShopMapPin else { return }
        
        annotationView.pinTintColor = .blue
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = annotation.logo()
        annotationView.leftCalloutAccessoryView = imageView
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

    func goToShopDetail(shop: Shop) {
        print("Go to shop detail")
        self.shopDetail = shop
        performSegue(withIdentifier: self.GO_TO_SHOP_DETAIL, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
            case self.GO_TO_SHOP_DETAIL:
                let shopDetailVC = ShopDetailViewController()
                shopDetailVC.shop = self.shopDetail
                break
            default:
                break
        }
    }
}

