//
//  AddNewAddressCell.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddNewAddressCell: UITableViewCell {

    @IBOutlet weak var addNewAddress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    addNewAddress.setTitle(APPLocalize.localizestring.addNewAddress.localize(), for: .normal)
        
        Common.setFont(to: addNewAddress, isTitle: true, size: 15, fontType: .semiBold)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
