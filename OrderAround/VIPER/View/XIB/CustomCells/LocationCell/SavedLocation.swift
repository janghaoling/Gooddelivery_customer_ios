//
//  SavedLocation.swift
//  Project
//
//  Created by CSS on 18/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class SavedLocation: UITableViewCell {
    
    @IBOutlet weak var lblLocationType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var type: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCustomFont()
    }
    func setCustomFont() {
        Common.setFont(to: lblLocationType, isTitle: true, size: 16, fontType: .semiBold)
        Common.setFont(to: lblAddress, isTitle: false, size: 12, fontType: .regular)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
