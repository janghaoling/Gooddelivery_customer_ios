//
//  CustomTabBarView.swift
//  orderAround
//
//  Created by CSS on 22/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class CustomTabBarView : UIView {
    
    
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
        let window = UIApplication.shared.windows.first
        let baseheight = self.frame.size.height
        if #available(iOS 11.0, *) {
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: baseheight + bottomPadding).isActive = true
            for sView in self.subviews {
                let Ypos = sView.frame.origin.y
                sView.translatesAutoresizingMaskIntoConstraints = true
                sView.frame.origin.y = (bottomPadding - Ypos)
            }
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    
}
