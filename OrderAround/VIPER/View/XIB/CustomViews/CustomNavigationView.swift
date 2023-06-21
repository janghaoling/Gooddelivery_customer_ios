//
//  CustomNavigationView.swift
//  orderAround
//
//  Created by CSS on 22/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit
class CustomNavigationBar : UIView {
    
    static let navBarHeight = 45.0
    
    var frameUpdated:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        basicSetup()
        
    }
    
    private func basicSetup() {
        if frameUpdated {return}
        frameUpdated = true
        let window = UIApplication.shared.windows.first
        if #available(iOS 11.0, *) {
            let topPadding = window?.safeAreaInsets.top ?? 0
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: 45 + topPadding).isActive = true
            
            for sView in self.subviews {
                let Ypos = sView.frame.origin.y
                sView.translatesAutoresizingMaskIntoConstraints = true
                sView.frame.origin.y = (topPadding + Ypos)
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
}
