//
//  PromoCode.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class PromoCode: UITableViewCell {
    
    @IBOutlet weak var labelPromoCodeName:UILabel!
    @IBOutlet weak var labelExpiryDate:UILabel!
    @IBOutlet weak var buttonApply:UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setFont()
        localize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Methods

extension PromoCode {
    
    
    private func setFont() {
        Common.setFont(to: labelPromoCodeName, isTitle: true, size: 17, fontType: .medium)
        Common.setFont(to: labelExpiryDate, isTitle: false, size: 15, fontType: .medium)
        Common.setFont(to: buttonApply, isTitle: false, size: 13)
    }
    
    private func localize(){
        self.buttonApply.setTitle(APPLocalize.localizestring.apply.localize().uppercased(), for: .normal)
    }
    
}
