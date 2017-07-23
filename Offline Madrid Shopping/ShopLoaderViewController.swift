//
//  ViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

class ShopLoaderViewController: UIViewController {

    let TITLE = "Offline Madrid Shopping"
   
    let SHOPPING_MAP_SEGUE = "goToShoppingMapSegue"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TITLE
    }
    
    func loadShops(destinationController: ShoppingMapViewController) -> Void {
        print("loading shops ...")
        activityIndicator.startAnimating()
        
        let loadShopInteractor = LoadShopsInteractor()
        loadShopInteractor.execute(completion: { (shops: [Shop]) in
            destinationController.shops = shops
            self.activityIndicator.stopAnimating()
        }) { (error: Error) in
            fatalError(error.localizedDescription)
            self.activityIndicator.stopAnimating()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case self.SHOPPING_MAP_SEGUE:
            let shoppingMapVC = segue.destination as! ShoppingMapViewController
            loadShops(destinationController: shoppingMapVC)
            break
        default:
            // Nothing to do
            return
        }
        
    }
}

