//
//  ShopLocation+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 24/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData
import UIKit

extension ShopLocation {

    public convenience init(from shopJson: ShopJson, context: NSManagedObjectContext) {
        self.init(context: context)
        
        let allowedChars = "-01234567890."
        
        var latString = (shopJson["gps_lat"] as? String) ?? ""
        latString = String(latString.characters.filter { allowedChars.characters.contains($0) })
        var lonString = (shopJson["gps_lon"] as? String) ?? ""
        lonString = String(lonString.characters.filter { allowedChars.characters.contains($0) })
        
        // A missing or malformed coordinate keeps the Core Data default (0)
        // instead of crashing the whole import.
        self.latitude = Double(latString) ?? 0
        self.longitude = Double(lonString) ?? 0
    }
    
    func locationImage() -> UIImage? {
        var image: UIImage? = nil
        if let imageData = self.image?.data as Data? {
            image = UIImage(data: imageData)
        }
        
        if let mapImage = image {
            return mapImage
        }
        
        return UIImage(named: "staticmap-no-location")
    }
}
