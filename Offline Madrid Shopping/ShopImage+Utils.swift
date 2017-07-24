//
//  ShopImage+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 24/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData
import UIKit

extension ShopImage {
    public convenience init(url: String, image: UIImage, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.url = url
        if let data = UIImagePNGRepresentation(image) as NSData? {
            self.data = data
        }
    }
}
