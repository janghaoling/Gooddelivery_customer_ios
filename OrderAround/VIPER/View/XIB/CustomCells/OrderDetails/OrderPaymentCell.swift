//
//  OrderDetailsFooterCell.swift
//  Project
//
//  Created by CSS on 25/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class OrderPaymentCell: UITableViewCell {
    
    @IBOutlet weak var viewItemTotal:UIView!
    @IBOutlet weak var viewTax:UIView!
    @IBOutlet weak var viewDeliveryCharge:UIView!
    @IBOutlet weak var viewDiscount:UIView!
    @IBOutlet weak var viewWallet:UIView!
    
    @IBOutlet weak var labelItemTotal:UILabel!
    @IBOutlet weak var labelTax:UILabel!
    @IBOutlet weak var labelDelivery:UILabel!
    @IBOutlet weak var labelDiscount:UILabel!
    @IBOutlet weak var labelWallet:UILabel!

    @IBOutlet weak var labelTotalValue:UILabel!
    @IBOutlet weak var labelTaxValue:UILabel!
    @IBOutlet weak var labelDeliveryValue:UILabel!
    @IBOutlet weak var labelDiscountValue:UILabel!
    @IBOutlet weak var labelWalletValue:UILabel!
    
    @IBOutlet weak var labelPayable:UILabel!
    @IBOutlet weak var labelToPayValue:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPaymentValues(invoice:Invoice) {
        viewDiscount.isHidden =  invoice.discount == 0
        viewDeliveryCharge.isHidden =  invoice.delivery_charge == 0
        viewTax.isHidden =  invoice.tax == 0
        viewWallet.isHidden =  invoice.wallet_amount == 0
       
        labelTaxValue.text = Common.showAmount(amount: invoice.tax ?? 0)
        labelDeliveryValue.text = Common.showAmount(amount: invoice.delivery_charge ?? 0)
        labelWalletValue.text = "-"+Common.showAmount(amount: invoice.wallet_amount ?? 0)
        labelDiscountValue.text = "-"+Common.showAmount(amount: invoice.discount ?? 0)
        labelToPayValue.text = Common.showAmount(amount: invoice.payable ?? 0)
        labelTotalValue.text = Common.showAmount(amount: invoice.gross ?? 0)
    }
    
}

//MARK: - Methods

extension OrderPaymentCell {
    private func initialLoads() {
        Common.setFont(to: labelItemTotal, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelTax, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelDelivery, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelDiscount, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelWallet, isTitle: false, size: 14, fontType: .regular)
        
        Common.setFont(to: labelTotalValue, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelTaxValue, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelDeliveryValue, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelDiscountValue, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelWalletValue, isTitle: false, size: 14, fontType: .regular)
        
        Common.setFont(to: labelPayable, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelToPayValue, isTitle: false, size: 14, fontType: .regular)
        labelTax.textColor = .greenColor
        localize()
    }
    
    private func localize() {
        labelItemTotal.text = APPLocalize.localizestring.cartTotalItem.localize()
        labelTax.text = APPLocalize.localizestring.seriveTax.localize()
        labelDelivery.text = APPLocalize.localizestring.deliveryCharge.localize()
        labelDiscount.text = APPLocalize.localizestring.discount.localize()
        labelWallet.text = APPLocalize.localizestring.walletDeduction.localize() 
        labelPayable.text = APPLocalize.localizestring.pay.localize()
    }
}
