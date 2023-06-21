//
//  OnBoardPageViewCell.swift
//  orderAround
//
//  Created by CSS on 19/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class OnBoardPageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data:WalKThroughData) {
        self.imageView.image = data.image
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.description
    }
}
