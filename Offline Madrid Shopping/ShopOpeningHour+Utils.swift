//
//  ShopOpeningHour+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData

extension ShopOpeningHour {
    @NSManaged private var _language: String
    
    var language: Language {
        get {
            return Language(rawValue: self._language)!
        }
        set {
            self._language = newValue.rawValue
        }
    }
    
    public convenience init(from shopJson: ShopJson, language: Language, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.language = language
        if language == Language.spanish {
            self.text = (shopJson["opening_hours_es"] as! String)
        }
        
        self.text = (shopJson["opening_hours_en"] as! String)
    }
}
