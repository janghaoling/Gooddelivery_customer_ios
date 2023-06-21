//
//  String.swift
//  User
//
//  Created by imac on 12/22/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

extension String {
    
    static var Empty : String {
        return ""
    }
    
    static func removeNil(_ value : String?) -> String{
        return value ?? String.Empty
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    //MARK:- Remove Empty spaces
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
  
    
    //MARK:- FirstLette Uppercase
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
        
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    
    
    func localize()->String{
        
        
//        guard let path = Bundle.main.path(forResource: LocalizeManager.currentlocalization(), ofType: "lproj") else {
//            return NSLocalizedString(self, comment: "returns a chosen localized string")
//        }
//        let bundle = Bundle(path: path)
        return NSLocalizedString(self, bundle: currentBundle!, comment: "")
        
    }
    
    //Mark:- Localize String varibale
    var localized: String {
        
        guard let path = Bundle.main.path(forResource: LocalizeManager.currentlocalization(), ofType: "lproj") else {
            return NSLocalizedString(self, comment: "returns a chosen localized string")
        }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
    
}
