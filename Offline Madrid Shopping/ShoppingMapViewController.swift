//
//  ShoppingMapViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

class ShoppingMapViewController: UIViewController {

    private let TITLE = "Madrid Shopping Map"
    
    var shops: [Shop]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TITLE
        
        print("ShoppingMapViewController.viewDidLoad: shops = \( shops?.count ?? 0)")
    }
    
    
}
