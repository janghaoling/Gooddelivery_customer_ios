//
//  EmptyDataView.swift
//  orderAround
//
//  Created by Ansar on 01/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {
    
    var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints =  false
        return imgView
    }()
    
    lazy var labelTitle:UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.numberOfLines = 0
       title.lineBreakMode = .byWordWrapping
        Common.setFont(to: title, isTitle: true, size: 16, fontType: .bold)
        return title
    }()
    
    lazy var labelDescription:UILabel = {
        let desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.textAlignment = .center
        desc.lineBreakMode = .byWordWrapping
        desc.numberOfLines = 0
        Common.setFont(to: desc, isTitle: false, size: 14, fontType: .light)
        return desc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(labelTitle)
        self.addSubview(labelDescription)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         setConstraints()
    }
    func setConstraints() {
        imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive  =  true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive =  true
        if #available(iOS 11.0, *) {
            imageView.centerXAnchor.constraintEqualToSystemSpacingAfter(self.centerXAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        let  ypos  = (self.frame.size.height/2) * 0.5
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: ypos).isActive =  true
        if #available(iOS 11.0, *) {
            labelTitle.topAnchor.constraintEqualToSystemSpacingBelow(imageView.bottomAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            labelTitle.leftAnchor.constraintEqualToSystemSpacingAfter(self.leftAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            labelTitle.rightAnchor.constraintEqualToSystemSpacingAfter(self.rightAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            labelDescription.topAnchor.constraintEqualToSystemSpacingBelow(labelTitle.bottomAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            labelDescription.leadingAnchor.constraintEqualToSystemSpacingAfter(self.leadingAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            labelDescription.trailingAnchor.constraintEqualToSystemSpacingAfter(self.trailingAnchor, multiplier: 1.0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        labelDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }

}

extension UITableView {
    
    func  setBackgroundImageAndTitle(imageName:String,title:String,description:String) {
        let emptyDataView = EmptyDataView(frame: self.bounds)
        emptyDataView.imageView.image = UIImage(named: imageName)
        emptyDataView.labelTitle.text = title
        emptyDataView.labelDescription.text = description
        self.backgroundView = emptyDataView
        
    }
}
