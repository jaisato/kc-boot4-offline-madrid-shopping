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
        // Not Bundle.main.preferredLocalizations: it only offers localizations
        // the bundle contains, and this one has nothing but Base.lproj, so it
        // answered "en" on every device and the Spanish descriptions and
        // opening hours, downloaded and stored with each shop, were never
        // shown. Match the user's preferred languages against the languages
        // the shop data comes in instead ("es-ES" or "es-MX" give "es").
        let shopLanguages = [Language.english.name(), Language.spanish.name()]
        guard let langName = Bundle.preferredLocalizations(from: shopLanguages).first else {
            return Language.english
        }
        print("Device Language: \(langName)")
        return Language.getLanguage(from: langName)
    }
}
