//
//  AddCartCell.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddCartCell: UITableViewCell {
    @IBOutlet weak var viewFullMenu: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!

    @IBOutlet weak var customizableLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var sideImageView: UIImageView!
    @IBOutlet weak var addCart: UIButton!
    @IBOutlet weak var cartCountLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var tilteLbl: UILabel!
    @IBOutlet weak var vegIcon: UIImageView!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
