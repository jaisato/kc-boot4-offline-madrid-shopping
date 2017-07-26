//
//  ShopOpeningHour+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import CoreData

extension ShopOpeningHour {
    
    public convenience init(from shopJson: ShopJson, language: Language, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.language = language.name()
        
        if language == Language.spanish {
            self.text = (shopJson["opening_hours_es"] as! String)
            return
        }
        
        self.text = (shopJson["opening_hours_en"] as! String)
    }
}
