//
//  LogoutCell.swift
//  Project
//
//  Created by CSS on 18/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class LogoutCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelAppVersion:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        Common.setFont(to: labelTitle, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: labelAppVersion, isTitle: false, size: 12, fontType: .light)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


