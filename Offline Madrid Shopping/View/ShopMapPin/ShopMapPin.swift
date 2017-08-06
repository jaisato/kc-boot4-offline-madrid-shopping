//
//  ShopMapPin.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 30/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation
import MapKit

class ShopMapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var shop: Shop!
    
    init(coordinate: CLLocationCoordinate2D, shop: Shop) {
        self.coordinate = coordinate
        self.shop = shop
        self.title = shop.name
        self.subtitle = shop.address
    }
    
    func logo() -> UIImage? {
        var image: UIImage? = nil
        if let imageData = self.shop.logo?.data as Data? {
            image = UIImage(data: imageData)
        }
        
        guard ((image) != nil) else {
            return UIImage(named: "shop-icon")
        }
        
        return image
    }
}
