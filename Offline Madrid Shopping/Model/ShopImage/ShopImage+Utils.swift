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
        // Without coordinates there is nothing to download: the static map of
        // 0, 0 is open sea. No image, and locationImage() shows the bundled
        // "staticmap-no-location".
        guard location.hasKnownCoordinates else {
            return nil
        }

        // The Static Maps API rejects every request without an API key (HTTP
        // 403, "You must use an API key to authenticate each request"), and
        // this URL never had one: every shop's map failed to download, one
        // wasted request per shop on each load, and the detail always showed
        // the bundled placeholder. Without a key there is nothing to ask
        // for, so no image is created and locationImage() shows that same
        // placeholder straight away. See staticMapsAPIKey().
        guard let apiKey = ShopImage.staticMapsAPIKey() else {
            return nil
        }

        let latitude = location.latitude
        let longitude = location.longitude
        // https, not http. The Static Maps API has served TLS for years, and
        // over plaintext anything on the path can read which coordinates the
        // user is looking at and swap the image that comes back.
        let mapImageUrl = "https://maps.googleapis.com/maps/api/staticmap?center=\( latitude ),\( longitude )&zoom=17&size=320x220&scale=2&markers=%7Ccolor:0x9C7B14%7C\( latitude ),\( longitude )&key=\( apiKey )"
        
        guard let defaultMapImage = UIImage(named: "staticmap-no-location"),
            let mapImageData = UIImageJPEGRepresentation(defaultMapImage, 1) as NSData? else {
            return nil
        }
        
        return ShopImage(url: mapImageUrl, data: mapImageData, context: context)
    }

    /// The Google Static Maps API key, percent-encoded for the query string,
    /// or nil when there is none. It comes from the GOOGLE_STATIC_MAPS_API_KEY
    /// entry of Info.plist, which the build setting of the same name fills,
    /// so the key never has to be written into a tracked file. An undefined
    /// build setting leaves the entry empty. See the README.
    static func staticMapsAPIKey() -> String? {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_STATIC_MAPS_API_KEY") as? String,
            !key.isEmpty,
            !key.hasPrefix("$(") else {
            return nil
        }

        return key.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
    }
}
