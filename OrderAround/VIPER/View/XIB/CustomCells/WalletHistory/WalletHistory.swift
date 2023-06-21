//
//  WalletHistory.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class WalletHistory: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setWalletDetails(title:String,status:String,amount:String) {
        self.titleLabel.text = title
        self.amountLabel.text = "$\(amount)"
        self.statusLabel.text = status
    }
    
    
}
