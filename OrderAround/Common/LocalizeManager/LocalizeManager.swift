//
//  LocalizeManager.swift
//  orderAround
//
//  Created by CSS on 22/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation


enum Language : String, Codable, CaseIterable {
    case english = "en"
    case arabic = "ar"
    case spanish = "es"
    
    
    var code : String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        case .spanish:
            return "es"
        }
    }
    
    var title : String {
        switch self {
        case .english:
            return APPLocalize.localizestring.English
        case .arabic:
            return APPLocalize.localizestring.Arabic
        case .spanish:
            return APPLocalize.localizestring.Spanish
        }
    }
    
    static var count: Int{ return 2 }
}


class LocalizeManager {
    
    static func changeLocalization(language:Language) {
        let defaults = UserDefaults.standard
        defaults.set(language.rawValue, forKey: "Language")
        UserDefaults.standard.synchronize()
    }
    
    static func currentlocalization() -> String {
        if let savedLocale = UserDefaults.standard.object(forKey: "Language") as? String {
            return savedLocale
        }
        return Language.english.rawValue
    }
    
    static func currentLanguage() -> String{
        
        switch LocalizeManager.currentlocalization() {
        case Language.english.rawValue:
            return Constants.string.English.localize()
        case Language.arabic.rawValue:
            return Constants.string.Arabic.localize()
        case Language.spanish.rawValue:
            return Constants.string.Spanish.localize()
            
        default:
            return ""
        }
    }
}
