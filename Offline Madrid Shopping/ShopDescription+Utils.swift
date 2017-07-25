//
//  ShopDescription+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData

extension ShopDescription {
    @NSManaged private var _language: String
    
    var language: Language {
        get {
            switch _language {
            case Language.spanish.name():
                return Language.spanish
            default:
                return Language.english
            }
        }
        set {
            self._language = newValue.name()
        }
    }
    
    public convenience init(from shopJson: ShopJson, language: Language, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.language = language
        
        if language == Language.spanish {
            self.text = (shopJson["description_es"] as! String)
            return
        }
        
        self.text = (shopJson["description_en"] as! String)
    }
}
