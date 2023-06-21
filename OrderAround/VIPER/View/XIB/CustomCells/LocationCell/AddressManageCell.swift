//
//  AddressManageCell.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddressManageCell: UITableViewCell {

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var editAddress: UIButton!
    @IBOutlet weak var typeName: UILabel!
    @IBOutlet weak var deleteAddress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         Common.setFont(to: addressLbl, isTitle: false, size: 13, fontType: .semiBold)
         Common.setFont(to: typeName, isTitle: false, size: 14, fontType: .semiBold)
         Common.setFont(to: editAddress, isTitle: true, size: 15, fontType: .semiBold)
         Common.setFont(to: deleteAddress, isTitle: true, size: 15, fontType: .semiBold)
         deleteAddress.setTitle(APPLocalize.localizestring.delete.localize(), for: .normal)
         editAddress.setTitle(APPLocalize.localizestring.edit.localize(), for: .normal)
    }
   
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
