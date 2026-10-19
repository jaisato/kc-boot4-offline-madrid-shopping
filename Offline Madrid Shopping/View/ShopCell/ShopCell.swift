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
    
    // Every field is assigned on every call. Cells are reused, and the old
    // "only if present" assignments left the previous shop's name, address
    // or logo on screen whenever the new one was missing that field.
    // logoImage() also falls back to the bundled icon when the stored data
    // does not decode, instead of leaving the image view empty.
    func loadData(shop: Shop) {
        self.nameLabel.text = shop.name
        self.addressLabel.text = shop.address
        self.shopLogoImage?.image = shop.logoImage()
    }
}
