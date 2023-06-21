//
//  BaseTabController.swift
//  Project
//
//  Created by CSS on 15/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class BaseTabController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


extension BaseTabController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 0 {
            
        } else if item.tag == 1 {
            
        } else if item.tag == 2 {
            
        } else if item.tag == 3 {
            
        } else {
            
        }
    }
}
