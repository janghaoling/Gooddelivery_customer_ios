//
//  ImageView.swift
//  User
//
//  Created by CSS on 09/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
@IBDesignable
class ImageView: UIImageView {

    //MARK:- Make Rounded Corner
    @IBInspectable
    var isRoundedCorner : Bool = false {
        
        didSet {
            
            if isRoundedCorner {
                self.layer.masksToBounds = true
                self.layer.cornerRadius =  frame.height/2
            }
        }
        
    }

    //MARK:- Make Image Tint Color
    @IBInspectable
    var isImageTintColor : Bool = false {
        
        didSet {
            
            if isImageTintColor {
              
                self.image = self.image?.withRenderingMode(.alwaysTemplate)
    
            }
        }
        
    }
    
    
}

extension  UIImageView   {
    //MARK: Tint Color
    func imageTintColor(color1: UIColor) { // -> UIImage
        UIGraphicsBeginImageContextWithOptions(self.image!.size, false, (self.image?.scale)!)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.image!.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.image!.size.width, height: self.image!.size.height))
        context?.clip(to: rect, mask: self.image!.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
//        return newImage!
    }
}
