//
//  ViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import CoreData

class ShopLoaderViewController: UIViewController {
    private let TITLE = "Offline Madrid Shopping"
    private let SHOPPING_MAP_SEGUE = "goToShoppingMapSegue"
    
    private var shops: [Shop] = []
    private var coreDataManager: CoreDataManager!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreDataManager = CoreDataManager()
        self.title = TITLE
    }
    
    @IBAction func loadShopsTapped(_ sender: Any) {
        loadShops()
    }
    
    // MARK: - Shop loading funcs
    
    private func loadShops() {
        print("Loading shops ...")
        activityIndicator.startAnimating()
        
        let loadShopArrayInteractor = LoadShopArrayInteractor()
        loadShopArrayInteractor.execute(completion: { (shops: [Shop]) in
            self.shops = shops
            
            guard self.shops.count > 0 else {
                return self.downloadShops()
            }
            
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: self.SHOPPING_MAP_SEGUE, sender: self)
        }) { (error: Error) in
            self.activityIndicator.stopAnimating()
            self.createAlert(title: "Error loading shops", message: error.localizedDescription)
        }
    }
    
    private func downloadShops() {
        print("Downloading shops ...")
        activityIndicator.startAnimating()
        
        let loadShopJsonArrayInteractor = LoadShopJsonArrayInteractor()
        loadShopJsonArrayInteractor.execute(completion: { (shopJsonArray: ShopJsonArray) in
            print("Completion: shops downloaded \( shopJsonArray.count )")
            self.saveShops(shopJsonArray: shopJsonArray)
        }) { (error: Error) in
            self.activityIndicator.stopAnimating()
            self.createAlert(title: "Error loading shops", message: error.localizedDescription)
        }
    }

    // MARK: - Shop storage funcs
    
    private func saveShops(shopJsonArray: ShopJsonArray) {
        print("saveShops ...")
        guard shopJsonArray.count > 0 else {
            self.activityIndicator.stopAnimating()
            self.createAlert(title: "Loading shops", message: "Sorry, there's no shops")
            return
        }
    
        saveAllShops(shopJsonArray: shopJsonArray)
    }

    private func saveAllShops(shopJsonArray: ShopJsonArray) {
        let saveAllShopsInteractor = SaveAllShopsInteractor()
        saveAllShopsInteractor.execute(from: shopJsonArray, completion: { (shops: [Shop]) in
            self.shops = shops
            self.saveAllShopImages(shops: self.shops)
        },
        onError: { (error: Error) in
            self.activityIndicator.stopAnimating()
            self.createAlert(title: "Error saving shops", message: error.localizedDescription)
        })
    }
    
    private func saveAllShopImages(shops: [Shop]) {
        let loadAllShopImagesInteractor = LoadAllShopImagesInteractor(
            interactor: LoadShopImageInteractor(),
            coreDataManager: CoreDataManager()
        )
        
        loadAllShopImagesInteractor.execute(from: shops, completion: { (shopsWithImages: [Shop]) in
            self.shops = shopsWithImages
            let container = self.coreDataManager.persistentContainer(dbName: self.coreDataManager.DB_NAME)
            self.coreDataManager.saveContext(context: container.viewContext)
            
            self.activityIndicator.stopAnimating()
            
            self.performSegue(withIdentifier: self.SHOPPING_MAP_SEGUE, sender: self)
        }) { (error: Error) in
            self.activityIndicator.stopAnimating()
            self.createAlert(title: "Error loading shop images", message: "\(error)")
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case self.SHOPPING_MAP_SEGUE:
            let shoppingMapVC = segue.destination as! ShoppingMapViewController
            shoppingMapVC.shops = self.shops
            shoppingMapVC.language = Locale.getDeviceLanguage()
            shoppingMapVC.coreDataManager = self.coreDataManager
            break
        default:
            // Nothing to do
            return
        }
    }
    
    // MARK: - Info/Error Alerts
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}

