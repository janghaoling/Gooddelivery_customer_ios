//
//  OrderTrackCell.swift
//  Project
//
//  Created by CSS on 25/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class OrderTrackCell: UITableViewCell {


    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var imageLine:UIImageView!
    
    var isFontBold = false {
        didSet{
            isFontBold ? Common.setFont(to: labelTitle, isTitle: true, size: 17, fontType: .bold) : Common.setFont(to: labelTitle, isTitle: true, size: 15, fontType: .semiBold)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    
}

extension OrderTrackCell {
    private func initialLoads() {
        Common.setFont(to: labelTitle, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: labelDescription, isTitle: true, size: 13, fontType: .light)
        labelDescription.textColor = .lightGray
    }
}
