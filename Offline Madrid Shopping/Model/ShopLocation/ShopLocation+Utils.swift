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
        // instead of crashing the whole import. So does one out of range: the
        // model limits latitude to [-90, 90] and longitude to [-180, 180], and
        // a value outside failed validation on save, where saveContext ends
        // in fatalError.
        self.latitude = ShopLocation.coordinate(from: latString, limit: 90)
        self.longitude = ShopLocation.coordinate(from: lonString, limit: 180)
    }
    
    private static func coordinate(from text: String, limit: Double) -> Double {
        guard let value = Double(text), abs(value) <= limit else {
            return 0
        }
        return value
    }
    
    /// False when the shop came without usable coordinates (both left at 0):
    /// there is no shop of Madrid at 0, 0, in the Gulf of Guinea.
    var hasKnownCoordinates: Bool {
        return latitude != 0 || longitude != 0
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
