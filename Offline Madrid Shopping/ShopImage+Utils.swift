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
    
    public convenience init(url: String, data: NSData, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.url = url
        self.data = data
    }
}
