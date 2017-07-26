//
//  ViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

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
        self.loadShops()
    }
    
    func loadShops() {
        print("Loading shops ...")
        activityIndicator.startAnimating()
        
        let loadShopsInteractor = LoadShopsInteractor()
        loadShopsInteractor.execute(completion: { (shopJsonArray: ShopJsonArray) in
            print("Completion: loaded shops \( shopJsonArray.count )")
            
            if shopJsonArray.count > 0 {
                let loadAllShopImagesInteractor = LoadAllShopImagesInteractor(interactor: LoadShopImageInteractor(), coreDataManager: self.coreDataManager)
                let container = self.coreDataManager.persistentContainer(dbName: self.coreDataManager.DB_NAME)
                
                let saveAllShopsInteractor = SaveAllShopsInteractor()
                saveAllShopsInteractor.execute(from: shopJsonArray, completion: { (shops: [Shop]) in
                    
                    loadAllShopImagesInteractor.execute(from: shops, completion: {
                        // ...
                        self.coreDataManager.saveContext(context: container.viewContext)
                        
                        self.shops = shops
                        
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: self.SHOPPING_MAP_SEGUE, sender: self)
                    }, onError: { (error: Error) in
                        self.activityIndicator.stopAnimating()
                        self.createAlert(title: "Error loading shop images", message: error.localizedDescription)
                    })
                    
                }, onError: { (error: Error) in
                    self.activityIndicator.stopAnimating()
                    self.createAlert(title: "Error saving shops", message: error.localizedDescription)
                })
                
            } else {
                // There's no shop
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: self.SHOPPING_MAP_SEGUE, sender: self)
            }
            
        }) { (error: Error) in
            self.activityIndicator.stopAnimating()
            self.createAlert(title: "Error loading shops", message: error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case self.SHOPPING_MAP_SEGUE:
            let shoppingMapVC = segue.destination as! ShoppingMapViewController
            shoppingMapVC.shops = self.shops
            
            break
        default:
            // Nothing to do
            return
        }
    }
    
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

