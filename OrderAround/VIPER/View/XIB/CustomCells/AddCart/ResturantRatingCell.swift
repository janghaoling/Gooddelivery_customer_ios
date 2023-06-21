//
//  ResturantRatingCell.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class ResturantRatingCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelRatingCount: UILabel!
    @IBOutlet weak var labelDelivery: UILabel!
    @IBOutlet weak var labelOfferPercentage: UILabel!
    @IBOutlet weak var imageOffer: UIImageView!
    @IBOutlet weak var labelRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension ResturantRatingCell {
    private func initialLoads() {
        Common.setFont(to: labelTime, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelRatingCount, isTitle: false, size: 14, fontType: .light)
        Common.setFont(to: labelDelivery, isTitle: false, size: 12, fontType: .light)
        Common.setFont(to: labelOfferPercentage, isTitle: false, size: 12, fontType: .regular)
        Common.setFont(to: labelRating, isTitle: false, size: 14, fontType: .regular)
        imageOffer.imageTintColor(color1: .red)
        labelOfferPercentage.textColor = .red
        labelDelivery.textColor = .lightGray
    }
}
