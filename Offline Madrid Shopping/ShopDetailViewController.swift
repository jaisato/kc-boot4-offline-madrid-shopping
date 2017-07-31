//
//  ShopDetailViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 30/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

class ShopDetailViewController: UIViewController {

    var shop: Shop!

    @IBOutlet weak var shopMapImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopHoursLabel: UILabel!
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    @IBOutlet weak var shopImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = shop.name
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        loadShopData()
    }

    private func loadShopData() {
        shopMapImage.image = shop.location?.locationImage()
        logoImage.image = shop.logoImage()
        shopNameLabel.text = shop.name
        shopAddressLabel.text = shop.address
        shopHoursLabel.text = shop.hours(in: Language.spanish)?.text
        shopDescriptionLabel.text = shop.description(in: Language.spanish)?.text
        shopImageView.image = shop.shopImage()
    }
}
