//
//  ButtonExtension.swift
//  orderAround
//
//  Created by CSS on 25/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

extension UIButton {
    
    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        let imageYpos = (self.frame.size.height / 2) - (imageViewSize.height/2) - titleLabelSize.height
        self.imageEdgeInsets = UIEdgeInsets(
            top: imageYpos,
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: (imageYpos + imageViewSize.height),
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
    
    func changeTint(color:UIColor) {
        if let image = self.imageView?.image {
            
            self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        self.tintColor = color
        setTitleColor(color, for: .normal)
    }
    
}
