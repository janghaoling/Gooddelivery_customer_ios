//
//  UIFontExtension.swift
//  orderAround
//
//  Created by Rajes on 08/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

extension UIFont {
    
    //MARK:- Semi Bold Family
    static func BoldLarge() -> UIFont {
        return UIFont(name: FontCustom.semiBold.rawValue, size:CGFloat(StandardSize.Large.rawValue)) ?? UIFont.systemFont(ofSize:CGFloat(StandardSize.Large.rawValue) )
    }
    static func BoldRegular() -> UIFont {
        return UIFont(name: FontCustom.semiBold.rawValue, size:CGFloat(StandardSize.Regular.rawValue)) ?? UIFont.systemFont(ofSize:CGFloat(StandardSize.Regular.rawValue) )
    }
    static func BoldSmall() -> UIFont {
        return UIFont(name: FontCustom.semiBold.rawValue, size:CGFloat(StandardSize.Small.rawValue)) ?? UIFont.systemFont(ofSize:CGFloat(StandardSize.Small.rawValue) )
    }
    
    static func BoldExtraSmall() -> UIFont {
        return UIFont(name: FontCustom.semiBold.rawValue, size:CGFloat(StandardSize.ExtraSmall.rawValue)) ?? UIFont.systemFont(ofSize:CGFloat(StandardSize.Small.rawValue) )
    }
    
    
    static func Regular() -> UIFont{
         return UIFont(name: FontCustom.regular.rawValue, size:CGFloat(StandardSize.Regular.rawValue)) ?? UIFont.systemFont(ofSize:CGFloat(StandardSize.Regular.rawValue) )
    }
    
}


enum StandardSize: Float {
   
    case Large = 18.0
    case Regular = 16.0
    case Small = 12.0
    case ExtraSmall = 10.0
//    case h1 = 20.0
//    case h2 = 18.0
//    case h3 = 16.0
//    case h4 = 14.0
//    case h5 = 12.0
//    case h6 = 10.0
}
