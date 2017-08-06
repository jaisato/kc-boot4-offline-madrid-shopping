//
//  ShopDetailViewController.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 30/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit
import CoreData

class ShopDetailViewController: UITableViewController {

    var shop: Shop!
    
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopHoursLabel: UILabel!
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    @IBOutlet weak var shopMapImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = self.shop.name
        
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
