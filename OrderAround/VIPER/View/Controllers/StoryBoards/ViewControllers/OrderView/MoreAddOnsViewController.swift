//
//  MoreAddOnsViewController.swift
//  orderAround
//
//  Created by CSS on 20/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class MoreAddOnsViewController: UIViewController {

    @IBOutlet weak var vegOrNonVegImageView: UIImageView!
    
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var addOnsCountLabel: UILabel!
    @IBOutlet weak var addOnsLabel: UILabel!
    @IBOutlet weak var customizationLabel: UILabel!
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var featureProduct: Featured_products?
    var product: Products?
    var isFromFeatureProduct = false
    var isFromCartPage = Bool()

    var qty = Int()
    var cartId = 0
    weak var delegate: MoreAddOnsViewControllerDelegate?
    var addOnsArray:NSMutableArray = []
    var cartListAddons = [Cart_addons]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chooseButton.layer.borderWidth = 1
        chooseButton.layer.borderColor = UIColor(red: 64/255, green: 187/255, blue: 55/255, alpha: 1).cgColor
        
        if isFromFeatureProduct {
            
            print(addOnsArray)
            dishLabel.text = featureProduct?.name
            if Double((featureProduct?.prices?.price)!) > (featureProduct?.prices?.orignal_price)! {
                priceLabel.text = (featureProduct?.prices?.currency)! +  "\(Double((featureProduct?.prices?.price)!))"
                offerPriceLabel.isHidden = false
                offerPriceLabel.text = (featureProduct?.prices?.currency)! +  "\(Double((featureProduct?.prices?.orignal_price)!))"
                print("offer price there")
                priceLabel.textColor = UIColor.lightGray
                let attributedString = NSMutableAttributedString(string: priceLabel.text!)
                
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                priceLabel.attributedText = attributedString
                
            }else{
                priceLabel.textColor = UIColor.black
              offerPriceLabel.isHidden = true
                priceLabel.text = (featureProduct?.prices?.currency)! +  "\(Double(featureProduct?.prices?.price ?? 0.0))"
                print("offer price not there")
                
            }
            var addonsNameArr = [String]()
            addonsNameArr.removeAll()
            
            for item in (featureProduct?.cart)! {
                for i in 0..<(item.cart_addons!.count)
                {
                    let Result = item.cart_addons![i]
                    let str = "\(Result.addon_product?.addon?.name! ?? "")"
                    
                    addonsNameArr.append(str)
                    let quantity = Result.quantity

                    let parameters = [
                        "id":  Result.addon_product?.id ?? 0,
                        "qty": quantity ?? 0.0
                        ] as [String : Any]
                    addOnsArray.add(parameters)
                }
                if item.cart_addons?.count == 0 {
                    addOnsLabel.text = "No Add-Ons"
                    addOnsCountLabel.isHidden = true
                }else{
                    addOnsCountLabel.isHidden = false
                    addOnsCountLabel.text = "+" + "\(item.cart_addons?.count ?? 0)" + "Add On"
                    let addonsstr = addonsNameArr.joined(separator: ", ")
                    addOnsLabel.text = addonsstr
                }
            }
            
            if featureProduct?.food_type == VEGORNONVEG().veg {
                vegOrNonVegImageView.image = #imageLiteral(resourceName: "veg")
            } else {
                
                vegOrNonVegImageView.image = #imageLiteral(resourceName: "nonveg")
            }
        }else{
            dishLabel.text = product?.name
            if Double((product?.prices?.price)!) > (product?.prices?.orignal_price)! {
                priceLabel.text = (product?.prices?.currency)! +  "\(Double((product?.prices?.price)!))"
               offerPriceLabel.isHidden = false
                offerPriceLabel.text = (product?.prices?.currency)! +  "\(Double((product?.prices?.orignal_price)!))"
                print("offer price there")
                priceLabel.textColor = UIColor.lightGray
                let attributedString = NSMutableAttributedString(string: priceLabel.text!)
                
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                priceLabel.attributedText = attributedString
                
            }else{
                priceLabel.textColor = UIColor.black
                offerPriceLabel.isHidden = true
                priceLabel.text = (product?.prices?.currency)! +  "\(Double(product?.prices?.price ?? 0.0))"
                print("offer price not there")
                
            }
            
            var addonsNameArr = [String]()
            addonsNameArr.removeAll()
            
            if isFromCartPage{
                
                for i in 0..<(cartListAddons.count)
                {
                    let Result = cartListAddons[i]
                    let str = "\(Result.addon_product?.addon?.name! ?? "")"
                    
                    addonsNameArr.append(str)
                    let quantity = Result.quantity
                    
                    let parameters = [
                        "id":  Result.addon_product?.id ?? 0,
                        "qty": quantity ?? 0.0
                        ] as [String : Any]
                    addOnsArray.add(parameters)
                    
                }
                if cartListAddons.count == 0 {
                    addOnsLabel.text = "No Add-Ons"
                    addOnsCountLabel.isHidden = true
                }else{
                    addOnsCountLabel.isHidden = false
                    addOnsCountLabel.text = "+" + "\(cartListAddons.count )" + " Add On"
                    let addonsstr = addonsNameArr.joined(separator: ", ")
                    addOnsLabel.text = addonsstr
                }

            }
            else{
                
                if product?.cart?.count ?? 0 > 0  {
                    for item in (product?.cart ?? []) {
                        for var i in 0..<(item.cart_addons!.count)
                        {
                            let Result = item.cart_addons![i]
                            
                            let str = "\(Result.addon_product?.addon?.name! ?? "")"
                            
                            addonsNameArr.append(str)
                            let quantity = Result.quantity
                            
                            let parameters = [
                                "id":  Result.addon_product?.id ?? 0,
                                "qty": quantity ?? 0.0
                                ] as [String : Any]
                            addOnsArray.add(parameters)
                            
                        }
                        if item.cart_addons?.count == 0 {
                            addOnsLabel.text = "No Add-Ons"
                            addOnsCountLabel.isHidden = true
                        }else{
                            addOnsCountLabel.isHidden = false
                            addOnsCountLabel.text = "+" + "\(item.cart_addons?.count ?? 0)" + " Add On"
                            let addonsstr = addonsNameArr.joined(separator: ", ")
                            addOnsLabel.text = addonsstr
                        }
                    }
                }
                else{
                    addOnsLabel.text = "No Add-Ons"
                    addOnsCountLabel.isHidden = true
                }
            }
           
            if product?.food_type == VEGORNONVEG().veg {
                vegOrNonVegImageView.image = #imageLiteral(resourceName: "veg")
            } else {
                
                vegOrNonVegImageView.image = #imageLiteral(resourceName: "nonveg")
            }
        }
    }
    
    @IBAction func onClickDisMissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRepeatAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if isFromFeatureProduct {
            delegate?.repeatFeatureProduct(featureProduct: featureProduct!, addOnsArr: addOnsArray)
            
        }else{
            delegate?.repeatProduct(product: product!, addOnsArr: addOnsArray, qty: self.qty, cartId: self.cartId)
        }
    }
    
    @IBAction func onChooseAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        if isFromFeatureProduct {
            delegate?.chooseFeatureProductCartItemAction(featureProduct: featureProduct!)

        }else{
            delegate?.chooseProductCartItemAction(product: product!)

        }
    }
}

protocol MoreAddOnsViewControllerDelegate: class {
    func chooseProductCartItemAction(product: Products)
    func chooseFeatureProductCartItemAction(featureProduct: Featured_products)
    func repeatProduct(product: Products,addOnsArr: NSMutableArray,qty: Int,cartId: Int)
    func repeatFeatureProduct(featureProduct: Featured_products,addOnsArr: NSMutableArray)
}
