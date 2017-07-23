//
//  Shop+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 22/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

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
    
    public convenience init(from shopJson: ShopJson) {
        self.init()
        
        self.id = shopJson["id"] as! Int32
        self.name = (shopJson["name"] as! String)
        self.address = (shopJson["address"] as! String)
        
        self.phone = shopJson["telephone"] as? String
        self.email = shopJson["email"] as? String
        self.url = shopJson["url"] as? String
        
        // Shop Images
        self.image = ShopImage()
        self.image?.url = shopJson["img"] as? String
        // TODO: image data
        self.logo = ShopImage()
        self.logo?.url = shopJson["logo_img"] as? String
        // TODO: image data
        
        // Shop location (Coordinates)
        
        
        // Multivalue data (by language)
        let enDescription = ShopDescription()
        enDescription.language = Language.english
        enDescription.text = (shopJson["description_en"] as! String)
        
        let esDescription = ShopDescription()
        esDescription.language = Language.spanish
        esDescription.text = (shopJson["description_es"] as! String)
        
        self.addToDescriptions(NSSet(array: [esDescription, enDescription]))
        
        let enOpeningHours = ShopOpeningHour()
        enOpeningHours.language = Language.english
        enOpeningHours.text = (shopJson["opening_hours_en"] as! String)
        
        let esOpeningHours = ShopOpeningHour()
        esOpeningHours.language = Language.spanish
        esOpeningHours.text = (shopJson["opening_hours_es"] as! String)
        
        self.addToOpeningHours(NSSet(array: [esOpeningHours, enOpeningHours]))
        
        let enKeywords = ShopKeywords()
        enKeywords.language = Language.english
        enKeywords.text = (shopJson["keywords_en"] as! String)
        
        let esKeywords = ShopKeywords()
        esKeywords.language = Language.spanish
        esKeywords.text = (shopJson["keywords_es"] as! String)
        
        self.addToKeywords(NSSet(array: [esKeywords, enKeywords]))
        
    }
}
