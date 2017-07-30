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
        
        let allowedChars = "01234567890."
        
        var latString = shopJson["gps_lat"] as! String
        latString = String(latString.characters.filter { allowedChars.characters.contains($0) })
        var lonString = shopJson["gps_lon"] as! String
        lonString = String(lonString.characters.filter { allowedChars.characters.contains($0) })
        
        let latitude = Double(latString)
        let longitude = Double(lonString)
        
        self.latitude = latitude!
        self.longitude = longitude!
    }
}
