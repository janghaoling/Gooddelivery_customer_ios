//
//  OrderListCell.swift
//  Project
//
//  Created by CSS on 15/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {

    
    @IBOutlet weak var imageRestaurant: UIImageView!
    @IBOutlet weak var imageRatingStar: UIImageView!
    @IBOutlet weak var imageoffers: UIImageView!
    
    @IBOutlet weak var labelShopDescription: UILabel!
    @IBOutlet weak var labelRestaurantName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelOffer: UILabel!
    @IBOutlet weak var viewOffers: UIView!
    @IBOutlet weak var labelClosed: UILabel!
    
    var isShopClosed = false {
        didSet {
            self.labelClosed.isHidden = !isShopClosed
            if isShopClosed {
                self.labelClosed.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.labelClosed.text = APPLocalize.localizestring.closed.localize()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDesigns()
        self.selectionStyle = .none
        self.backgroundColor = .clear

    }
    
    func rotateAnimation(imageView:UIImageView,duration: CFTimeInterval = 2.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
        
        imageView.layer.add(rotateAnimation, forKey: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    func setDesigns() {
        Common.setFont(to: labelRestaurantName, isTitle: true, size: 13, fontType: .bold)
        Common.setFont(to: labelShopDescription, isTitle: false, size: 12, fontType: .light)
        Common.setFont(to: labelOffer, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelTime, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelRating, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelClosed, isTitle: false, size: 12, fontType: .regular)
        imageoffers.image = UIImage(named: "offer_icon")
        imageoffers.imageTintColor(color1: .red)
        labelOffer.textColor = .red
        labelShopDescription.textColor = .lightGray
        imageRatingStar.image = UIImage(named: "star-black")
    }
    
    func set(values:Shops)  {
        
        imageRestaurant.setImage(with: values.avatar, placeHolder: #imageLiteral(resourceName: "restaurant_placeholder"))
        labelRestaurantName.text = values.name
        isShopClosed = (values.shopstatus == APPLocalize.localizestring.closed.localize()) ? true : false
        labelShopDescription.text = values.description
        if let offer = values.offer_percent {
            labelOffer.isHidden = false
            labelOffer.text = APPLocalize.localizestring.flat.localize()+"\(offer)"+APPLocalize.localizestring.offOrder.localize()
        }else{
            labelOffer.isHidden = true
        }
        if let estimateTime = values.estimated_delivery_time {
            labelTime.text = "\(estimateTime)"+APPLocalize.localizestring.mins.localize()
        }
        if values.rating != 0 {
            labelRating.text = "\(values.rating!)"+APPLocalize.localizestring.Rating.localize()
        }else{
            labelRating.text = APPLocalize.localizestring.noRating.localize()
        }
        self.viewOffers.isHidden = values.offer_percent == 0
    }
    
}
