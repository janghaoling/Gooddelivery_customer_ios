//
//  DishesListCell.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class DishesListCell: UITableViewCell {
    
    
    @IBOutlet weak var lblViewFullMenu: UILabel!
    @IBOutlet weak var lblProduct:UILabel!
    @IBOutlet weak var lblProductDescription:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var btnViewFullMenu:UIButton!
    @IBOutlet weak var btnPlus:UIButton!
    @IBOutlet weak var btnMinus:UIButton!
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var imgVegNon:UIImageView!
    @IBOutlet weak var lblQty:UILabel!

    var isVegOrNon = false{
        didSet {
            isVegOrNon ? (imgVegNon.image = #imageLiteral(resourceName: "veg")) : (imgVegNon.image = #imageLiteral(resourceName: "nonveg"))
        }
    }
    var quantity:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDesign()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setDesign()  {
        Common.setFont(to: lblProduct, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: lblProductDescription, isTitle: true, size: 12, fontType: .regular)
        Common.setFont(to: lblPrice, isTitle: true, size: 12, fontType: .regular)
        Common.setFont(to: lblViewFullMenu, isTitle: true, size: 12, fontType: .regular)

        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    
    func set(values:Products) {
        print(values)
        let foodType = VEGORNONVEG()
        isVegOrNon = (values.food_type == foodType.veg ? true : false)
        lblPrice.text = (values.prices?.currency)! + String(format: "%.2f", (values.prices?.price ?? 0))
        lblProduct.text = values.name

        
        if values.cart?.count != 0 {
            quantity = values.cart?.first?.quantity
            lblQty.text = "\(quantity!)"
        }
        btnPlus.isHidden = !(Int.val(val: values.cart?.count)>0)
        btnMinus.isHidden = !(Int.val(val: values.cart?.count)>0)
        lblQty.isHidden = !(Int.val(val: values.cart?.count)>0)

        btnAdd.isHidden = (Int.val(val: values.cart?.count)>0)
    }
    
    
   
  
}
