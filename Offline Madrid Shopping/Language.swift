//
//  Language.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 23/7/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

@objc
public enum Language: Int {
    case english, spanish
    
    public func name () -> String {
        switch self {
        case .english:
            return "en"
        case .spanish:
            return "es"
        }
    }
}
