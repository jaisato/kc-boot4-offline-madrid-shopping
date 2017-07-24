//
//  ShopLocation+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 24/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData

extension ShopLocation {
    public convenience init(from shopJson: ShopJson, context: NSManagedObjectContext) {
        self.init(context: context)
        
        if let lat = Double(shopJson["gps_lat"] as! String) {
            self.latitude = lat
        }
        if let lon = Double(shopJson["gps_lon"] as! String) {
            self.longitude = lon
        }
    }
}
