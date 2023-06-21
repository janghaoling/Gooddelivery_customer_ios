//
//  AddOnsViewController.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddOnsViewController: UIViewController, UIScrollViewDelegate {

     //MARK: - Declarations.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartItemLbl: UILabel!
    @IBOutlet weak var addLbl: UILabel!
    var productDict: Products?
    var featuredProducts: Featured_products?
    var isFromFeaturedProducts = false
    @IBOutlet weak var cartImgView: UIImageView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var addCartButton: UIButton!
    var addCart: AddCart?
    var cartList: Cart?

    private var cartId = 0
    private var quantity = 0.0
    private var productId = 0
    var totalItemPrice = 0
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    var delegate: AddCartUpdateDelegate?
    var addOnsArray:NSMutableArray = []

    
    //MARK: - View life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        cartViewAnimShow(subView: self.cartView)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.cartView.bounds.height, 0)

        addCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        tableView.register(UINib(nibName: XIB.Names.ItemImageCell, bundle: nil), forCellReuseIdentifier: XIB.Names.ItemImageCell)
        tableView.register(UINib(nibName: XIB.Names.ItemDescriptions, bundle: nil), forCellReuseIdentifier: XIB.Names.ItemDescriptions)
        tableView.register(UINib(nibName: XIB.Names.CustomNotesCell, bundle: nil), forCellReuseIdentifier: XIB.Names.CustomNotesCell)
        tableView.register(UINib(nibName: XIB.Names.AddOnsCell, bundle: nil), forCellReuseIdentifier: XIB.Names.AddOnsCell)
        
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if isFromFeaturedProducts {
            totalItemPrice = Int(featuredProducts?.prices?.orignal_price ?? 0)
        }else{
            totalItemPrice = Int(productDict?.prices?.orignal_price ?? 0.0)
        }
        
        localize()
        setCustomFont()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isFromFeaturedProducts == true {
           
             self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (featuredProducts?.prices?.currency)! + "\((featuredProducts?.prices?.orignal_price)!)"
        } else {
            if productDict != nil {
                
                self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() + (productDict?.prices?.currency)! + "\((productDict?.prices?.orignal_price)!)"
            }
      }
    }
    
}

//MARK: - StringLocalize & Font design
extension AddOnsViewController {
    
    func localize() {
        addLbl.text = APPLocalize.localizestring.addItem.localize()
    }

    func setCustomFont() {
        Common.setFont(to: addLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: cartItemLbl, isTitle: true, size: 14, fontType: .semiBold)
    }
    
}

//MARK: - Button Actions
extension AddOnsViewController {
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
    
    //MARK:- go back
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.delegate?.didReceiveAddCartUpdate(isRefreshPage: false)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDelegate & UITableViewDatasource

extension AddOnsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            if isFromFeaturedProducts {
                return featuredProducts?.addons?.count ?? 0

            }else{
                return productDict?.addons?.count ?? 0

            }
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 220
        case 1:
            return 109
        case 2:
            return 45
        case 3:
            return 192
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.ItemImageCell, for: indexPath) as! ItemImageCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            let nibPost = UINib(nibName: XIB.Names.TrendingCell, bundle: nil)
            cell.collectionView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.TrendingCell)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            cell.collectionView.collectionViewLayout = layout
            
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            cell.collectionView.alwaysBounceHorizontal = false
            cell.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if isFromFeaturedProducts == true {
                cell.itemImage = featuredProducts?.images ?? []
            } else {
                cell.itemImage  = productDict?.images ?? []
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.ItemDescriptions, for: indexPath) as! ItemDescriptions
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            if isFromFeaturedProducts == true {
                cell.productName.text = featuredProducts?.name
                cell.priceLbl.text =  (featuredProducts?.prices?.currency)! + "\((featuredProducts?.prices?.orignal_price)!)"
                cell.descriptionLbl.text = featuredProducts?.description
                
            } else {
              if productDict != nil {
                cell.productName.text = productDict?.name
                cell.priceLbl.text =  (productDict?.prices?.currency)! + "\((productDict?.prices?.orignal_price)!)"
                cell.descriptionLbl.text = productDict?.description
                }
            }
            return cell
      
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddOnsCell, for: indexPath) as! AddOnsCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if isFromFeaturedProducts {
                cell.setData(addons: (featuredProducts?.addons![indexPath.row])!)

            }else{
                cell.setData(addons: (productDict?.addons![indexPath.row])!)

            }
            cell.addButton.isHidden = false
            cell.viewPlusMinus.isHidden = true
            
            cell.minusButton.tag = indexPath.row
            cell.minusButton.addTarget(self, action: #selector(minusButtonAction(sender:)), for: .touchUpInside)
            cell.plusButton.tag = indexPath.row
            cell.plusButton.addTarget(self, action: #selector(plusButtonAction(sender:)), for: .touchUpInside)
            cell.checkButton.tag = indexPath.row
            cell.checkButton.addTarget(self, action: #selector(checkButtonAction(sender:)), for: .touchUpInside)
            cell.addButton.tag = indexPath.row
            cell.addButton.addTarget(self, action: #selector(addButtonAction(sender:)), for: .touchUpInside)
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CustomNotesCell) as! CustomNotesCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.textView.delegate = self
            
            return cell
          
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CustomNotesCell, for: indexPath) as! CustomNotesCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
    }
}

//MARK: - TextView Delegate

extension AddOnsViewController: UITextViewDelegate {
    
    @objc func showKeyboard(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func hideKeyboard(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = APPLocalize.localizestring.writeSomething.localize()
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK: - PostViewProtocol
extension AddOnsViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
    }
    
    //Callback for addCart
    func addCart(api: Base, data: CartList?) {
        self.loader.isHidden = true
        self.delegate?.didReceiveAddCartUpdate(isRefreshPage: true)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Add Cart
extension AddOnsViewController {
    @objc func minusButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 2)
        let cell = self.tableView.cellForRow(at: indexPath) as! AddOnsCell
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
        if isFromFeaturedProducts {
            let dict = self.featuredProducts?.addons?[indexPath.row]
            
            let parameters = [
                "id":  dict?.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict?.price)!
            let totalPrice = totalItemPrice - price
            totalItemPrice = totalPrice
            self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (featuredProducts?.prices?.currency)! + "\(totalPrice)"
            
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict?.id ?? 0 {
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                }
            }
        }else{
            let dict = self.productDict?.addons?[indexPath.row]
            let parameters = [
                "id":  dict?.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict?.price)!
            let totalPrice = totalItemPrice - price
            totalItemPrice = totalPrice
            self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (productDict?.prices?.currency)! + "\(totalPrice)"
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict?.id ?? 0 {
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                }
            }
        }
    }
    
    @objc func plusButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 2)
        
        let cell = self.tableView.cellForRow(at: indexPath) as! AddOnsCell
        
        let quantity = Int(cell.countLabel.text!)! + 1
        cell.countLabel.text = String(quantity)
        cell.checkImg.image = UIImage(named: "checked")

        if isFromFeaturedProducts {
            let dict = self.featuredProducts?.addons?[indexPath.row]
            let parameters = [
                "id":  dict?.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict?.price)!
            let totalPrice = totalItemPrice + price
            totalItemPrice = totalPrice

            self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (featuredProducts?.prices?.currency)! + "\(totalPrice)"
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict?.id ?? 0{
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                }
            }
        }else{
            let dict = self.productDict?.addons?[indexPath.row]
            let parameters = [
                "id":  dict?.id ?? 0,
                "qty": quantity
                ] as [String : Any]
            let price = (dict?.price)!
            let totalPrice = totalItemPrice + price
            totalItemPrice = totalPrice

            self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (productDict?.prices?.currency)! + "\(totalPrice)"
            
            for i in 0..<self.addOnsArray.count {
                let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                let id =  dictItem["id"] as? Int ?? 0
                if id == dict?.id ?? 0 {
                    addOnsArray.remove(dictItem)
                    addOnsArray.add(parameters)
                }
            }
        }
    }
    
    @objc func addButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 2)

        let cell = self.tableView.cellForRow(at: indexPath) as! AddOnsCell
        cell.addButton.isHidden = true
        cell.viewPlusMinus.isHidden = false
        cell.countLabel.text = "1"
        cell.checkImg.image = UIImage(named: "checked")
        if isFromFeaturedProducts {
            let dict = self.featuredProducts?.addons?[indexPath.row]
            let parameters = [
                "id":  dict?.id ?? 0,
                "qty": 1
                ] as [String : Any]
            if addOnsArray.contains(parameters){
                addOnsArray.remove(parameters)
                addOnsArray.add(parameters)
            }else{
                addOnsArray.add(parameters)
            }
            
            let totalPrice = totalItemPrice + (dict?.price)!
            totalItemPrice = totalPrice
            self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (featuredProducts?.prices?.currency)! + "\(totalPrice)"

        }else{
            let dict = self.productDict?.addons?[indexPath.row]
            let parameters = [
                "id":  dict?.id ?? 0,
                "qty": 1
                ] as [String : Any]
            
            if addOnsArray.contains(parameters){
                addOnsArray.remove(parameters)
                addOnsArray.add(parameters)
                
            }else{
                addOnsArray.add(parameters)
            }
            if productDict != nil {
                let totalPrice = totalItemPrice + (dict?.price)!
                self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (productDict?.prices?.currency)! + "\(totalPrice)"
                totalItemPrice = totalPrice
            
            }
        }
    }
    
    @objc func checkButtonAction(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 2)
        
       // let dictItem = SearchUserArr[buttonRow] as! NSDictionary
        let cell = self.tableView.cellForRow(at: indexPath) as! AddOnsCell
        
        if cell.checkImg.image == UIImage(named: "unchecked"){
            cell.checkImg.image = UIImage(named: "checked")
            cell.addButton.isHidden = true
            cell.viewPlusMinus.isHidden = false
            cell.countLabel.text = "1"
            
            if isFromFeaturedProducts {
                let dict = self.featuredProducts?.addons?[indexPath.row]
                let parameters = [
                    "id":  dict?.id ?? 0,
                    "qty": 1
                    ] as [String : Any]
                if self.addOnsArray.contains(parameters){
                    addOnsArray.remove(parameters)
                    addOnsArray.add(parameters)
                }else{
                    addOnsArray.add(parameters)
                }
                
                let price = (dict?.price)!
                let totalPrice = totalItemPrice + price
                self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (featuredProducts?.prices?.currency)! + "\(totalPrice)"
                totalItemPrice = totalPrice
            }else{
                let dict = self.productDict?.addons?[indexPath.row]
                let parameters = [
                    "id":  dict?.id ?? 0,
                    "qty": 1
                    ] as [String : Any]
                
                if self.addOnsArray.contains(parameters){
                    addOnsArray.remove(parameters)
                    addOnsArray.add(parameters)
                }else{
                    addOnsArray.add(parameters)
                }
                let price = (dict?.price)!
                let totalPrice = totalItemPrice + price
                self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (productDict?.prices?.currency)! + "\(totalPrice)"
                totalItemPrice = totalPrice
            }
            
        }else{
            cell.checkImg.image = UIImage(named: "unchecked")
            cell.addButton.isHidden = false
            cell.viewPlusMinus.isHidden = true
            
            if isFromFeaturedProducts {
                let dict = self.featuredProducts?.addons?[indexPath.row]
                
                let price = (dict?.price)!
                let totalPrice = totalItemPrice - price
                self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (featuredProducts?.prices?.currency)! + "\(totalPrice)"
                totalItemPrice = totalPrice
                
                for i in 0..<self.addOnsArray.count {
                    let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                    let id =  dictItem["id"] as? Int ?? 0
                    if id == dict?.id ?? 0 {
                        print(dictItem)
                        addOnsArray.remove(dictItem)
                        return
                    }
                }
                
            }else{
                let dict = self.productDict?.addons?[indexPath.row]
                
                let price = (dict?.price)!
                let totalPrice = totalItemPrice - price
                self.cartItemLbl.text = APPLocalize.localizestring.perItem.localize() +  (productDict?.prices?.currency)! + "\(totalPrice)"
                totalItemPrice = totalPrice
                for i in 0..<self.addOnsArray.count {
                    let dictItem = self.addOnsArray[i] as! Dictionary<String,Any>
                    let id =  dictItem["id"] as? Int ?? 0
                    if id == dict?.id ?? 0 {
                        addOnsArray.remove(dictItem)

                        return
                    }
                }
            }
        }
        
        print(addOnsArray)
    }
    
    @objc func addToCart(sender: UIButton) {
        print(addOnsArray)
        
        if isFromFeaturedProducts == true {
            if addOnsArray.count == 0 {
                self.addCart = AddCart()
                
                if (featuredProducts?.cart?.count)! > 0 {
                    self.addCart?.cart_id = featuredProducts?.cart?.first?.id
                    self.addCart?.quantity = (featuredProducts?.cart?.first?.quantity)! + 1
                    self.addCart?.product_id = featuredProducts?.id
                } else {
                    self.addCart?.cart_id = 0
                    self.addCart?.quantity = 1
                    self.addCart?.product_id = featuredProducts?.id
                }
                print(self.addCart!)

                self.loader.isHidden = false
                self.presenter?.post(api: .addCart, data: self.addCart?.toData())
            }else{
                self.addCart = AddCart()
                
//                if (featuredProducts?.cart?.count)! > 0 {
//                    self.addCart?.cart_id = featuredProducts?.cart?.first?.id
//                    self.addCart?.quantity = (featuredProducts?.cart?.first?.quantity)! + 1
//                    self.addCart?.product_id = featuredProducts?.id
//                } else {
                    self.addCart?.cart_id = 0
                    self.addCart?.quantity = 1
                    self.addCart?.product_id = featuredProducts?.id
//                }
                
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
                print(self.addCart!)
                self.loader.isHidden = false
                self.presenter?.post(api: .addCart, data: self.addCart?.toData())
            }
            
        } else {
            if addOnsArray.count == 0 {
                if productDict != nil {
                    
                    self.addCart = AddCart()
                    
                    if (productDict?.cart?.count)! > 0 {
                        
                        self.addCart?.cart_id = productDict?.cart?.first?.id
                        self.addCart?.quantity = (productDict?.cart?.first?.quantity)! + 1
                        self.addCart?.product_id = productDict?.id
                        
                    } else {
                        
                        self.addCart?.cart_id = 0
                        self.addCart?.quantity = 1
                        self.addCart?.product_id = productDict?.id
                    }
                    
                    self.loader.isHidden = false
                    self.presenter?.post(api: .addCart, data: self.addCart?.toData())
                }
            }else{
                if productDict != nil {
                    
                    self.addCart = AddCart()
                    
//                    if (productDict?.cart?.count)! > 0 {
//
//                        self.addCart?.cart_id = productDict?.cart?.first?.id
//                        self.addCart?.quantity = (productDict?.cart?.first?.quantity)! + 1
//                        self.addCart?.product_id = productDict?.id
//
//                    } else {
                    
                        self.addCart?.cart_id = 0
                        self.addCart?.quantity = 1
                        self.addCart?.product_id = productDict?.id
//                    }
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
                    self.presenter?.post(api: .addCart, data: self.addCart?.toData())
                }
            }
        }
    }
}



