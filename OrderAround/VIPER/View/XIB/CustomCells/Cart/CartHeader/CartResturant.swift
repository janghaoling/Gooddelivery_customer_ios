//
//  CartResturant.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CartResturant: UITableViewCell {

    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopDescriptionLbl: UILabel!
    @IBOutlet weak var shopNameLbl: UILabel!
    override func awakeFromNib() {
      
        super.awakeFromNib()
        // Initialization code
        
        Common.setFont(to: shopDescriptionLbl, isTitle: false, size: 12, fontType: .regular)
        
         Common.setFont(to: shopNameLbl, isTitle: false, size: 12, fontType: .semiBold)
    }

  
    
}
