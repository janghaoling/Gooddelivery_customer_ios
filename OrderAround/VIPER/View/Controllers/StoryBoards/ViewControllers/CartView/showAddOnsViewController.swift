//
//  showAddOnsViewController.swift
//  orderAround
//
//  Created by CSS on 14/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class showAddOnsViewController: UIViewController {
    
    @IBOutlet weak var updateItemButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var addOnsTableView: UITableView!
    @IBOutlet weak var addOnsLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var vegOrNonVegImageView: UIImageView!
    var cartList: Items?
    var totalItemPrice = 0.0
    var CustomizeaddOnsArray:NSMutableArray = []
    var addOnsArray:NSMutableArray = []
    var delegate: CartUpdateDelegate?
    var CartItemArr:NSMutableArray = []
    var quantityarr = [Int]()
    
    var addCart: AddCart?
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableViewRegister()
        setValues()
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func onClickAddItemAction(_ sender: Any) {
        print(addOnsArray)
        if CustomizeaddOnsArray.isEqual(addOnsArray){
            print("Equal")
            self.dismiss(animated: true, completion: nil)
        }else{
            print("Not Equal")
            self.addCart = AddCart()

            self.addCart?.cart_id = cartList!.id
            self.addCart?.quantity = Int(cartList?.quantity ?? 0.0)
            self.addCart?.product_id = cartList!.product!.id!
            
            var productId = [Int]()
            var qtyArr = [Int]()
            for i in 0..<addOnsArray.count {
                
                let Result = addOnsArray[i] as! NSDictionary
                let addOnsID = Result.value(forKey: "id") as? Int ?? 0
                let quantity = Result.value(forKey: "qty") as? Int ?? 0
                print(addOnsID)
                
                qtyArr.append(quantity)
                productId.append(addOnsID)
            }
            self.addCart?.product_addons = productId
            self.addCart?.addons_qty = qtyArr
            self.loader.isHidden = false
            print(self.addCart ?? "")
            self.presenter?.post(api: .addCart, data: self.addCart?.toData())
        }
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
extension showAddOnsViewController {
    private func tableViewRegister(){
        addOnsTableView.register(UINib(nibName: XIB.Names.AddOnsCell, bundle: nil), forCellReuseIdentifier: XIB.Names.AddOnsCell)
        
        addOnsTableView.separatorStyle = .none
        addOnsTableView.delegate = self
        addOnsTableView.dataSource = self
        addOnsTableView.reloadData()
    }
    private func setValues(){
        if cartList!.product?.food_type == VEGORNONVEG().veg {
            vegOrNonVegImageView.image = #imageLiteral(resourceName: "veg")
        } else {
            vegOrNonVegImageView.image = #imageLiteral(resourceName: "nonveg")
        }
        productNameLabel.text = cartList?.product?.name
        productPriceLabel.text = "\(cartList?.product?.prices?.orignal_price ?? 0)"
        var priceCount = [Int]()
        let totalPrice = (cartList!.product!.prices!.orignal_price!) * (cartList?.quantity ?? 0.0)
        priceCount.append(Int(totalPrice))
        
        if cartList?.cart_addons?.count != 0 {
            
            for item in (cartList?.cart_addons)! {
                
                let quantity = cartList?.quantity
                
                let price = Double(item.addon_product?.price ?? 0.0) * Double(item.quantity!)
                let totalPrice = Int(price ) * Int(quantity ?? 0.0)
                priceCount.append(totalPrice)
                
                let parameters = [
                    "id":  item.addon_product?.id ?? 0,
                    "qty": item.quantity ?? 0.0
                    ] as [String : Any]
                addOnsArray.add(parameters)
                CustomizeaddOnsArray.add(parameters)
                
            }
            
        }
        print(addOnsArray)
        let totalPriceAccount = priceCount.reduce(0, +)
        self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() +  "$" + "\(totalPriceAccount)"
        totalItemPrice = Double(totalPriceAccount)
        
    }
}
extension showAddOnsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartList?.cart_addons?.count == 0 {
            return (self.cartList?.product?.addons!.count)!
            
        }else{
            return (self.cartList?.cart_addons?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddOnsCell, for: indexPath) as! AddOnsCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        if cartList?.cart_addons?.count == 0 {
            cell.setDataAddOns(data: (self.cartList?.product?.addons![indexPath.row])!)
            
            
        }else{
            cell.setAddOnsCart(addOns: (self.cartList?.cart_addons?[indexPath.row])!)
            
        }

        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(minusButtonAction(sender:)), for: .touchUpInside)
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: #selector(plusButtonAction(sender:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        cell.checkButton.addTarget(self, action: #selector(checkButtonAction(sender:)), for: .touchUpInside)
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addButtonAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func minusButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 0)
        let cell = self.addOnsTableView.cellForRow(at: indexPath) as! AddOnsCell
        let quantity = Int(cell.countLabel.text!)! - 1
        cell.countLabel.text = String(quantity)
        
        if quantity > 0 {
            cell.addButton.isHidden = true
            cell.viewPlusMinus.isHidden = false
        }else{
            cell.addButton.isHidden = false
            cell.viewPlusMinus.isHidden = true
            cell.checkImg.image = UIImage(named: "unchecked")
        }
        if cartList?.cart_addons?.count != 0 {
            let dict = (self.cartList?.cart_addons?[indexPath.row])!
            
            let parameters = [
                "id":  dict.addon_product?.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict.addon_product?.price)!
            let totalPrice = totalItemPrice - price
            totalItemPrice = totalPrice
            self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() +  "$" + "\(totalPrice)"
            print(addOnsArray)
            
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict.addon_product?.id {
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                }
            }
        }else{
            let dict = (self.cartList?.product?.addons?[indexPath.row])!
            
            let parameters = [
                "id":  dict.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict.price)!
            let totalPrice = Int(totalItemPrice) - price
            totalItemPrice = Double(totalPrice)
            self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() +  "$" + "\(totalPrice)"
            print(addOnsArray)
            
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict.id {
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                    
                }
            }
        }
        
        print(addOnsArray)
        
    }
    
    @objc func plusButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 0)
        
        let cell = self.addOnsTableView.cellForRow(at: indexPath) as! AddOnsCell
        
        let quantity = Int(cell.countLabel.text!)! + 1
        cell.countLabel.text = String(quantity)
        cell.checkImg.image = UIImage(named: "checked")
        if cartList?.cart_addons?.count != 0 {
            
            let dict = (self.cartList?.cart_addons?[indexPath.row])!
            let parameters = [
                "id":  dict.addon_product?.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict.addon_product?.price)!
            let totalPrice = totalItemPrice + (price * Double(self.cartList!.quantity!))
            totalItemPrice = totalPrice
            
            self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() +  "$" + "\(totalPrice)"
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict.addon_product?.id {
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                }
            }
            
        }else{
            let dict = (self.cartList?.product?.addons?[indexPath.row])!
            let parameters = [
                "id":  dict.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict.price)!
            let totalPrice = Int(totalItemPrice) + price
            totalItemPrice = Double(totalPrice)
            
            self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() +  "$" + "\(totalPrice)"
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict.id {
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                }
            }
        }
        
    }
    
    @objc func addButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 0)
        
        let cell = self.addOnsTableView.cellForRow(at: indexPath) as! AddOnsCell
        cell.addButton.isHidden = true
        cell.viewPlusMinus.isHidden = false
        cell.countLabel.text = "1"
        cell.checkImg.image = UIImage(named: "checked")
        if cartList?.cart_addons?.count != 0 {
            
            let dict = (self.cartList?.cart_addons?[indexPath.row])!
            let parameters = [
                "id":  dict.addon_product?.id ?? 0,
                "qty": 1
                ] as [String : Any]
            
            addOnsArray.add(parameters)
            let totalPrice = totalItemPrice + (dict.addon_product?.price)!
            totalItemPrice = totalPrice
            self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() +  "$" + "\(totalPrice)"
        }else{
            let dict = (self.cartList?.product?.addons?[indexPath.row])!
            let parameters = [
                "id":  dict.id ?? 0,
                "qty": 1
                ] as [String : Any]
            
            addOnsArray.add(parameters)
            let totalPrice = Int(totalItemPrice) + (dict.price)!
            totalItemPrice = Double(totalPrice)
            self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() +  "$" + "\(totalPrice)"
        }
    }
    
    @objc func checkButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 0)
        let cell = self.addOnsTableView.cellForRow(at: indexPath) as! AddOnsCell
        
        if cell.checkImg.image == UIImage(named: "unchecked"){
            cell.checkImg.image = UIImage(named: "checked")
            cell.addButton.isHidden = true
            cell.viewPlusMinus.isHidden = false
            cell.countLabel.text = "1"
            if cartList?.cart_addons?.count != 0 {
                
                let dict = (self.cartList?.cart_addons?[indexPath.row])!
                let parameters = [
                    "id":  dict.addon_product?.id ?? 0,
                    "qty": 1
                    ] as [String : Any]
                
                addOnsArray.add(parameters)
                
                let price = (dict.addon_product?.price)!
                let totalPrice = totalItemPrice + price
                self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() + "$" + "\(totalPrice)"
                totalItemPrice = totalPrice
            }else{
                let dict = (self.cartList?.product?.addons?[indexPath.row])!
                let parameters = [
                    "id":  dict.id ?? 0,
                    "qty": 1
                    ] as [String : Any]
                
                addOnsArray.add(parameters)
                
                let price = (dict.price)!
                let totalPrice = Int(totalItemPrice) + price
                self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() + "$" + "\(totalPrice)"
                totalItemPrice = Double(totalPrice)
            }
        }else{
            cell.checkImg.image = UIImage(named: "unchecked")
            cell.addButton.isHidden = false
            cell.viewPlusMinus.isHidden = true
            if cartList?.cart_addons?.count != 0 {
                
                let dict = (self.cartList?.cart_addons?[indexPath.row])!
                
                let price = (dict.addon_product?.price)!
                let totalPrice = totalItemPrice - price
                self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() + "$" + "\(totalPrice)"
                totalItemPrice = totalPrice
                for i in 0..<self.addOnsArray.count {
                    let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                    let id =  dictItem["id"] as? Int ?? 0
                    if id == dict.addon_product?.id ?? 0 {
                        addOnsArray.remove(dictItem)
                    }
                }
            }else{
                let dict = (self.cartList?.product?.addons?[indexPath.row])!
                
                let price = (dict.price)!
                let totalPrice = Int(totalItemPrice) - price
                self.totalPriceLabel.text = APPLocalize.localizestring.perItem.localize() + "$" + "\(totalPrice)"
                totalItemPrice = Double(totalPrice)
                for i in 0..<self.addOnsArray.count {
                    let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                    let id =  dictItem["id"] as? Int ?? 0
                    if id == dict.id ?? 0 {
                        
                        addOnsArray.remove(dictItem)
                    }
                    
                }
            }
        }
    }

}
//MARK: - PostViewProtocol

extension showAddOnsViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
        
    }
    
    
    //Callback for addCart
    func addCart(api: Base, data: CartList?) {
        self.loader.isHidden = true
        self.delegate?.didReceiveAddCartUpdate()
        self.dismiss(animated: true, completion: nil)
    }
}


