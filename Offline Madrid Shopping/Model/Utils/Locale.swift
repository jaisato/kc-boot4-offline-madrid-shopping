//
//  Locale.swift
//  Offline Madrid Shopping
//
//  Created by Jairo on 6/8/17.
//  Copyright © 2017 JST. All rights reserved.
//

import Foundation

public class Locale {
    
    public static let ENGLISH = "en"
    public static let SPANISH = "es"
    
    public static func getDeviceLanguage() -> Language {
        guard let langName = Bundle.main.preferredLocalizations.first as String? else {
            return Language.english
        }
        print("Device Language: \(langName)")
        return Language.getLanguage(from: langName)
    }
}
