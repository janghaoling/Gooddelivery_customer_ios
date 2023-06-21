//
//  FilterCell.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         Common.setFont(to: self.titleLabel ?? UILabel(), size : 16, fontType : FontCustom.semiBold)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
