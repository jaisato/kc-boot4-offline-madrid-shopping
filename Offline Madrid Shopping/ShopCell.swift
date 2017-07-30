//
//  ShopCell.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 29/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {

    @IBOutlet weak var shopLogoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func loadData(shop: Shop) {
        if let name = shop.name {
            self.nameLabel.text = name
        }
        if let address = shop.address {
            self.addressLabel.text = address
        }
        if let image = shop.image?.data {
            self.shopLogoImage?.image = UIImage(data: image as Data)
        }
    }
}
