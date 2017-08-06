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
    
    public static func createShopLocationImage(location: ShopLocation, context: NSManagedObjectContext) -> ShopImage? {
        let latitude = location.latitude
        let longitude = location.longitude
        let mapImageUrl = "http://maps.googleapis.com/maps/api/staticmap?center=\( latitude ),\( longitude )&zoom=17&size=320x220&scale=2&markers=%7Ccolor:0x9C7B14%7C\( latitude ),\( longitude )"
        
        guard let defaultMapImage = UIImage(named: "staticmap-no-location"),
            let mapImageData = UIImageJPEGRepresentation(defaultMapImage, 1) as NSData? else {
            return nil
        }
        
        return ShopImage(url: mapImageUrl, data: mapImageData, context: context)
    }
}
