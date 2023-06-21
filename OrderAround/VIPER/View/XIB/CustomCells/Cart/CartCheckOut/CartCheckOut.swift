//
//  CartCheckOut.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CartCheckOut: UITableViewCell {

    @IBOutlet weak var promoCodeLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var addCustomNoteLbl: UILabel!
    @IBOutlet weak var discountAmountLbl: UILabel!
    @IBOutlet weak var serviceAmountLbl: UILabel!
    @IBOutlet weak var discountTextLbl: UILabel!
    @IBOutlet weak var deliveryFeeAmountLbl: UILabel!
    @IBOutlet weak var serviceTaxTextLbl: UILabel!
    @IBOutlet weak var totalItemCountLbl: UILabel!
    @IBOutlet weak var deliveryFeeTextLbl: UILabel!
    @IBOutlet weak var totalItemTextLbl: UILabel!
    @IBOutlet weak var toPayLbl: UILabel!
    @IBOutlet weak var walletAmountLbl: UILabel!
    @IBOutlet weak var useWalletLbl: UILabel!
    @IBOutlet weak var checkUnCheck: UIImageView!
    @IBOutlet weak var toPayAmountLbl: UILabel!
    @IBOutlet weak var customNotesButton: UIButton!
    @IBOutlet weak var useWalletButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setCustomFont()
        localized()
        
    }

    
    func setCustomFont() {
        
        Common.setFont(to: discountAmountLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: serviceAmountLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: discountTextLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: deliveryFeeAmountLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: serviceTaxTextLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: totalItemCountLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: deliveryFeeTextLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: totalItemTextLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: walletAmountLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: useWalletLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: toPayLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: toPayAmountLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: addCustomNoteLbl, isTitle: true, size: 14, fontType: .semiBold)
    }
    
    
    func localized() {
        promoCodeLabel.text = APPLocalize.localizestring.promoCode.localize()
        discountTextLbl.text = APPLocalize.localizestring.discount.localize()
        serviceTaxTextLbl.text = APPLocalize.localizestring.seriveTax.localize()
        deliveryFeeTextLbl.text = APPLocalize.localizestring.deliveryFee.localize()
        totalItemTextLbl.text = APPLocalize.localizestring.cartTotalItem.localize()
        useWalletLbl.text = APPLocalize.localizestring.wallet.localize()
        toPayLbl.text = APPLocalize.localizestring.pay.localize()
        addCustomNoteLbl.text = APPLocalize.localizestring.customNotes.localize()
        
    }
}
