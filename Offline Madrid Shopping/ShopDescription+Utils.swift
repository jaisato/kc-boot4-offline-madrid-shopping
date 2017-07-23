//
//  ShopDescription+Utils.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

extension ShopDescription {
    @NSManaged private var _language: String
    
    var language: Language {
        get {
            return Language(rawValue: self._language)!
        }
        set {
            self._language = newValue.rawValue
        }
    }
}
