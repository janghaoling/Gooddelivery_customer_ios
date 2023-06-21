//
//  OrderDetailsCell.swift
//  Project
//
//  Created by CSS on 25/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var imageFoodType: UIImageView!
    @IBOutlet weak var labelProduct: UILabel!
    @IBOutlet weak var labelAddOns: UILabel!
    
    var isVegOrNon = false{
        didSet {
            isVegOrNon ? (imageFoodType.image = #imageLiteral(resourceName: "veg")) : (imageFoodType.image = #imageLiteral(resourceName: "nonveg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        Common.setFont(to: labelPrice, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: labelProduct, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: labelAddOns, isTitle: true, size: 13, fontType: .regular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
