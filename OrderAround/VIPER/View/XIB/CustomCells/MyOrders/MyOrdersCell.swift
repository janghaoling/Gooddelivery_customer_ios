//
//  MyOrdersCell.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class MyOrdersCell: UITableViewCell {

    @IBOutlet weak var labelShopName:UILabel!
    @IBOutlet weak var labelShopAddress:UILabel!
    @IBOutlet weak var labelPrice:UILabel!
    @IBOutlet weak var labelDisputeStatus:UILabel!
    @IBOutlet weak var labelProducts:UILabel!
    @IBOutlet weak var labelOrderTime:UILabel!
    
    @IBOutlet weak var buttonReorder:UIButton!
    
    @IBOutlet weak var imageDispute:UIImageView!
    weak var delegate: MyOrderDetailDelegate?

    @IBOutlet weak var viewDispute:UIView!
    @IBOutlet weak var viewReorder:UIView!
    
    var orderDetails:OrderList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoad()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MyOrdersCell {
    private func initialLoad() {
        Common.setFont(to: labelShopName, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: labelShopAddress, isTitle: false, size: 13, fontType: .light)
        Common.setFont(to: labelDisputeStatus, isTitle: false, size: 14, fontType: .semiBold)
        Common.setFont(to: labelProducts, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelOrderTime, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: buttonReorder, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelPrice, isTitle: false, size: 14, fontType: .regular)
        
        labelShopAddress.textColor = .lightGray
        labelProducts.textColor = .darkGray
        labelOrderTime.textColor = .darkGray
        
        buttonReorder.setTitle(APPLocalize.localizestring.reorder.localize(), for: .normal) 
        buttonReorder.setTitleColor(.secondary, for: .normal)
        buttonReorder.layer.borderColor = UIColor.secondary.cgColor
        buttonReorder.layer.borderWidth = 1.0
        
        //disputeresolved
    }
    
    
    func setValues(values:OrderList) {
        self.orderDetails = values
        self.labelShopName.text = values.shop?.name
        self.labelShopAddress.text = values.shop?.address
        self.labelPrice.text = Common.showAmount(amount: values.invoice?.net ?? 0.0)
        self.labelOrderTime.text = values.schedule_status == 0 ? values.created_at : values.delivery_date
        
        self.labelDisputeStatus.text = values.dispute == DisputeStatus.CREATED.rawValue ? DisputeString.CREATED.rawValue : DisputeString.RESOLVE.rawValue
        let disputeImage = values.dispute == DisputeStatus.CREATED.rawValue ? "ic_dispute" : "ic_disputeresolved"
        self.imageDispute.image = UIImage(named: disputeImage)
        self.viewDispute.isHidden = values.dispute == DisputeStatus.NODISPUTE.rawValue
        self.labelDisputeStatus.textColor = values.dispute ==  DisputeStatus.CREATED.rawValue ? .red : UIColor.green
        if imageDispute.image != nil {
             self.imageDispute.imageTintColor(color1: values.dispute ==  DisputeStatus.CREATED.rawValue ? .red : UIColor.green)
        }
        
        var products = ""
        for item in values.items ?? [] {
            if let qty = item.quantity , let name = item.product?.name {
                products = products + name + "(" + "\(qty)" + ") ,"
            }
        }
        if products.count > 0 {
            products = String(products.dropLast())
        }
        self.labelProducts.text = products
        self.buttonReorder.addTarget(self, action: #selector(tapReorder), for: .touchUpInside)
    }
    
    @objc func tapReorder() {
        
        delegate?.pushtocartViewController(data: orderDetails!)
    }
    
    
    
}



protocol MyOrderDetailDelegate : class{
    func pushtocartViewController(data: OrderList)
}
