//
//  ItemDescriptions.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class ItemDescriptions: UITableViewCell {

    @IBOutlet weak var addonsLabel: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var vegOrNonVegIcon: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
