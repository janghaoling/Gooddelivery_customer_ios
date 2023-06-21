//
//  AddOnsCell.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddOnsCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var viewPlusMinus: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var addOnsNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        addButton.layer.borderWidth = 1
    }
    
    func setData(addons: Addons){
        let price = String(format: " $%.02f", Double(addons.price!))
        addOnsNameLabel.text = (addons.addon?.name)! + price 

        
        
    }
    
    func setDataAddOns(data: Addons){
        let price = String(format: " $%.02f", Double(data.price!))
        addOnsNameLabel.text = (data.addon?.name)! + price
        addButton.isHidden = false
        viewPlusMinus.isHidden = true
        
    }
    
    func setAddOnsCart(addOns: Cart_addons){
        
        if Int(addOns.quantity ?? 0.0) > 0 {
            addButton.isHidden = true
            viewPlusMinus.isHidden = false
            countLabel.text = "\(Int(addOns.quantity ?? 0.0))"
            checkImg.image = UIImage(named: "checked")
            
        }else{
            checkImg.image = UIImage(named: "unchecked")
            
            addButton.isHidden = false
            viewPlusMinus.isHidden = true
        }
        
            let price = String(format: " $%.02f", Double((addOns.addon_product?.price)!))
            addOnsNameLabel.text = (addOns.addon_product?.addon?.name)! + price
        
        
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
