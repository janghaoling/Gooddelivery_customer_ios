//
//  UserMenu.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class UserMenu: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var hiddenButton: UIButton!
    @IBOutlet weak var footerIcon: UIImageView!
    @IBOutlet weak var headerIcon: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        Common.setFont(to: hiddenButton, isTitle: true, size: 14, fontType: .semiBold)
        hiddenButton.setTitle(APPLocalize.localizestring.delete.localize(), for: .normal)
        Common.setFont(to: titleLbl, isTitle: true, size: 14, fontType: .semiBold)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
