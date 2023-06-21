//
//  CartListView.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CartListView: UITableViewCell {

    @IBOutlet weak var customizedlabel: UILabel!
    @IBOutlet weak var customizedButton: UIButton!
    @IBOutlet weak var addOnsLabel: UILabel!
    @IBOutlet weak var cartCount: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var removeFromCart: UIButton!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var vegOrNonVeg: UIImageView!
    @IBOutlet weak var customizedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        
        Common.setFont(to: cartCount, isTitle: true, size: 12, fontType: .regular)
        
          Common.setFont(to: itemNameLbl, isTitle: true, size: 12, fontType: .semiBold)
        
           Common.setFont(to: priceLbl, isTitle: true, size: 12, fontType: .semiBold)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
