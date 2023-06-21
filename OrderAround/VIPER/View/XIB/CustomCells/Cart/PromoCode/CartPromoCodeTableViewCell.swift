//
//  CartPromoCodeTableViewCell.swift
//  orderAround
//
//  Created by CSS on 18/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class CartPromoCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var btnApplied: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
