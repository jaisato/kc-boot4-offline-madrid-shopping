//
//  Shop+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData
import UIKit

public typealias ShopJson = Dictionary<String, Any>
public typealias ShopJsonArray = [ShopJson]
public typealias ShopJsonDict = Dictionary<String, ShopJsonArray>

extension Shop {
    /**
     "id": "1",
     "name": "Cortefiel - Preciados",
     "img": "https://madrid-shops.com/media/shops/cortefiel-small.jpg",
     "logo_img": "https://madrid-shops.com/media/shops/logo-cortefiel-200.jpg",
     "telephone": "(34) 91 522 64 31",
     "email": "",
     "url": "www.grupocortefiel.com",
     "address": "Puerta del Sol 11",
     "gps_lat": "40.4180563 ",
     "gps_lon": "-3.7010172999999895",
     "description_en": "An extensive network of stores spread across four continents makes Cortefiel Group one of the leading European companies in the fashion industry.  Through its four chains -Cortefiel, Pedro del Hierro, Springfield and Women'secret-, the Group operates in 58 countries with 1,647 points of sale. ",
     "description_es": "Una extensa red de tiendas distribuidas por cuatro continentes convierte a Grupo Cortefiel en una de las principales compañías europeas del sector moda. A través de sus cuatro cadenas –Cortefiel, Pedro del Hierro, Springfield y Women’secret-, el Grupo está presente en 58 países con 1.647 puntos de venta.",
     "opening_hours_en": "Monday to Saturday: 10: 00-21: 00",
     "opening_hours_es": "De Lunes a Sábado: 10:00-21:00",
     "keywords_en": "Cortefiel, Springfield, Pedro del Hierro, Women's Secret",
     "keywords_es": "Cortefiel, Springfield, Pedro del Hierro, Women’secret",
     **/
    
    public convenience init(from shopJson: ShopJson, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = Int32(shopJson["id"] as! String)!
        self.name = (shopJson["name"] as! String)
        self.address = (shopJson["address"] as! String)
        
        self.phone = shopJson["telephone"] as? String
        self.email = shopJson["email"] as? String
        self.url = shopJson["url"] as? String
    }
    
    func logoImage() -> UIImage? {
        var image: UIImage? = nil
        if let imageData = self.logo?.data as Data? {
            image = UIImage(data: imageData)
        }
        
        guard ((image) != nil) else {
            return UIImage(named: "shop-icon")
        }
        
        return image
    }
    
    func hours(in language: Language) -> ShopOpeningHour? {
        guard let shopHours: [ShopOpeningHour] = self.openingHours?.allObjects as? [ShopOpeningHour] else {
            return nil
        }
        
        return shopHours.filter({ (openingHour: ShopOpeningHour) -> Bool in
            return openingHour.language == language.name()
        }).first
    }
    
    func description(in language: Language) -> ShopDescription? {
        guard let shopDescriptions: [ShopDescription] = self.descriptions?.allObjects as? [ShopDescription] else {
            return nil
        }
        
        return shopDescriptions.filter({ (description: ShopDescription) -> Bool in
            return description.language == language.name()
        }).first
    }
    
    class func fetchRequestOrderedByName() -> NSFetchRequest<Shop> {
        let fetchRequest: NSFetchRequest<Shop> = Shop.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let addressSortDescriptor = NSSortDescriptor(key: "address", ascending: true)
        
        fetchRequest.sortDescriptors = [nameSortDescriptor, addressSortDescriptor]
        
        return fetchRequest
    }
}
