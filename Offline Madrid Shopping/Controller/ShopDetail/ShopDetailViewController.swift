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

    private let NUMBER_OF_SECTIONS = 1
    private let NUMBER_OF_ROWS_IN_SECTION = 5

    var language: Language!
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
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
        loadShopData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ROWS_IN_SECTION
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - View Data
    
    private func loadShopData() {
        shopMapImage.image = shop.location?.locationImage()
        logoImage.image = shop.logoImage()
        shopNameLabel.text = shop.name
        shopAddressLabel.text = shop.address
        shopHoursLabel.text = shop.hours(in: self.language)?.text
        shopDescriptionLabel.text = shop.description(in: self.language)?.text
        shopImageView.image = shop.shopImage()
    }
}
