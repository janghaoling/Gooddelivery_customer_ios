//
//  AddCartWithImgView.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddCartWithImgView: UITableViewCell {

    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var CustomizeableLabel: UILabel!
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var cartCountLbl: UILabel!
    @IBOutlet weak var removeCartButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var vegOrNonVegIcon: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dishNameLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
