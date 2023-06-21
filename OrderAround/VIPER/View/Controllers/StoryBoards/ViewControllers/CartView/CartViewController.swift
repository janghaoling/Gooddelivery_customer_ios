//
//  CartViewController.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import CoreLocation

struct USE_WALLET {
    
    let YES = 1
    let NO = 0
}

class CartViewController: UIViewController {
    
    @IBOutlet weak var locationTypeImgView: UIImageView!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressAddView: UIView!
    @IBOutlet weak var contiueView: UIView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var shimmerView: UIView!
    
    @IBOutlet weak var selectAdressBut: UIButton!
    @IBOutlet weak var addAdressButton: UIButton!
    @IBOutlet weak var addAdressBut: UIButton!
    @IBOutlet weak var contiueButton: UIButton!
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var cartList = [Items]()
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    var delegate: AddCartUpdateDelegate?

    var addCart: AddCart?
    var shop: Shops?
    var totalPrice = 0
    var discountPrice: String?
    var needToPay = 0.0
    var deliveryCharge: String?
    var serviceTax: Int = 0
    var taxPercent: Int = 0
    var cartCount = 0
    var isFromResturantCart = false
    var notes = String()
    var useWallet = Int()
    var addressId = Int()
    var isPromoCodeApplied = false
    var userAddressDetails:[UserAddressDetails]!

    
    //MARK: View Life cycles
    override func viewDidLoad() {
       super.viewDidLoad()
        
        tableView.register(UINib(nibName: XIB.Names.GoBackCell, bundle: nil), forCellReuseIdentifier: XIB.Names.GoBackCell)
        tableView.register(UINib(nibName: XIB.Names.CartListView, bundle: nil), forCellReuseIdentifier: XIB.Names.CartListView)
        tableView.register(UINib(nibName: XIB.Names.CartCheckOut, bundle: nil), forCellReuseIdentifier: XIB.Names.CartCheckOut)
        tableView.register(UINib(nibName: XIB.Names.CartPromoCodeTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.CartPromoCodeTableViewCell)
    
        tableView.register(UINib(nibName: XIB.Names.CartResturant, bundle: nil), forCellReuseIdentifier: XIB.Names.CartResturant)

        tableView.separatorStyle = .none
        
        localize()
        setCustomFont()
        locatingCurrentLocation()
        addAdressBut.isHidden = true
        self.locationTypeImgView.image = UIImage(named: "ic_location_unselect")//#imageLiteral(resourceName: "otherUnselected")
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if User.main.id != nil {
            self.tableView.backgroundView = nil
            let promoCodeId = UserDefaults.standard.object(forKey: "promoCodeId") as? Int ?? 0
            if promoCodeId == 0 {
                viewCartList()

            }else{
                
                var applyPromoCode = ApplyPromoCode()
                applyPromoCode.promocode_id = promoCodeId
                self.presenter?.get(api: .addCart, data: applyPromoCode.toData())

            }
        } else {
            self.tableView.setBackgroundImageAndTitle(imageName: EmptyImage.cartEmpty.rawValue, title: APPLocalize.localizestring.goodFoodIsAlwaysGettingCooked.localize(), description: APPLocalize.localizestring.pleaseOrderDish.localize())
        }
         setAddressViewDetails()
    }
    
    func locatingCurrentLocation() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    

    
    func setAddressViewDetails() {
        let userAddrees  = DataManager.shared.getSavedAddressArray()

        let selectedAddress = DataManager.shared.getSelectedAddressDetails()
        if let addressArray = userAddrees,addressArray.count > 0 {
            if let choosed = selectedAddress {
                if addressArray.count > 1 {
                    showDeliveryAddressDetails(address: choosed, changeAddrees: true)
                } else {
                    showDeliveryAddressDetails(address: choosed, changeAddrees: false)
                }
               
            } else {
                if let savedAddress = addressArray.first {
                     showDeliveryAddressDetails(address: savedAddress, changeAddrees: false)
                }
                
                 showCurrentAddressWithOptions()
            }
        
            
        } else {
            //Add Current Address
            currentAddressUI()
        }
    }
    
  
    func showDeliveryAddressDetails(address:UserAddressDetails,changeAddrees:Bool) {
        addressId = address.id ?? 0
        let type = address.type ?? ""
        switch type {
            case "home":
                self.locationLbl.text = "Delivery to Home"
                locationTypeImgView.image = #imageLiteral(resourceName: "ic_home_unselect")
            case "work":
                self.locationLbl.text = "Delivery to Work"
                locationTypeImgView.image = #imageLiteral(resourceName: "workUnselected")
            default:
               
              self.locationLbl.text = "Other"
              locationTypeImgView.image = #imageLiteral(resourceName: "ic_location_unselect")
        }
         self.addressLbl.text = address.map_address
        if changeAddrees {
            self.addAdressBut.setTitle(APPLocalize.localizestring.changeAddress.localize(), for: .normal)
        } else {
             self.addAdressBut.setTitle(APPLocalize.localizestring.addAddress.localize(), for: .normal)
        }
        self.addAdressBut.isHidden = false
        self.addressAddView.isHidden = true
        self.contiueView.isHidden = false
        
        if withSchedule {
            scheduleButton.isHidden = false
            contiueButton.isHidden = true
            btnContinue.isHidden = false
            
        } else {
            scheduleButton.isHidden = true
            btnContinue.isHidden = true
            contiueButton.isHidden = false

        }
        
        
    }
    
   
    func currentAddressUI(){
        self.addAdressBut.isHidden = true
        self.contiueView.isHidden = true
        self.addressAddView.isHidden = false
        self.selectAdressBut.isHidden = true
        self.addAdressButton.isHidden = false
        self.addAdressButton.setTitle(APPLocalize.localizestring.addAddressToProceed.localize(), for: .normal)
        self.addAdressButton.backgroundColor = UIColor.secondary
        self.addAdressButton.setTitleColor(UIColor.white, for: .normal)

    }
    
    func showCurrentAddressWithOptions(){
        self.addAdressBut.isHidden = true
        self.contiueView.isHidden = true
        self.addressAddView.isHidden = false
        self.selectAdressBut.isHidden = false
        self.addAdressButton.isHidden = false
        //self.addAdressButton.setTitle(Constants.string.other.localize(), for: .normal)
 
    }
    
    func otherAddressOnlyAddedUI(){
    
        self.addAdressBut.isHidden = false
        self.contiueView.isHidden = false
        self.addressAddView.isHidden = true
        self.selectAdressBut.isHidden = true
        self.addAdressButton.isHidden = false
        self.addAdressBut.setTitle(APPLocalize.localizestring.addAddress.localize(), for: .normal)
        if withSchedule {
            scheduleButton.isHidden = false
            contiueButton.isHidden = true
            btnContinue.isHidden = false
            
        } else {
            scheduleButton.isHidden = true
            btnContinue.isHidden = true
            contiueButton.isHidden = false
            
        }
    }
    
    @IBAction func onschedlueBtnView(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "showDatePickerVC")as! showDatePickerVC
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.addressId = self.addressId
        vc.notes = self.notes
        vc.useWallet = self.useWallet
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func onContinueBtnView(_ sender: Any) {
        let paymentVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PamentListViewController) as! PamentListViewController
        paymentVC.addressId = self.addressId
        paymentVC.notes = self.notes
        paymentVC.useWallet = self.useWallet
        paymentVC.isFromCartFlow = true
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
}


extension CartViewController {
    
    func localize() {
        contiueButton.setTitle(APPLocalize.localizestring.continues.localize().uppercased(), for: .normal)
        selectAdressBut.setTitle(APPLocalize.localizestring.selectAddress.localize(), for: .normal)
        addAdressBut.setTitle(APPLocalize.localizestring.addAddress.localize(), for: .normal)
        addAdressButton.setTitle(APPLocalize.localizestring.addAddress.localize(), for: .normal)
    }
    
    func setCustomFont() {
        
        Common.setFont(to: locationLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: addressLbl, isTitle: true, size: 14, fontType: .light)
        Common.setFont(to: contiueButton, isTitle: true, size: 17, fontType: .semiBold)
        Common.setFont(to: addAdressButton, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: addAdressBut, isTitle: true, size: 12, fontType: .semiBold)
        Common.setFont(to: selectAdressBut, isTitle: true, size: 14, fontType: .semiBold)
        
    }
    
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
}

//MARK:- Button Actions

extension CartViewController {
    
    @IBAction func continueClickEvent(_ sender: UIButton) {
        
        let paymentVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PamentListViewController) as! PamentListViewController
        paymentVC.addressId = self.addressId
        paymentVC.notes = self.notes
        paymentVC.useWallet = self.useWallet
        paymentVC.isFromCartFlow = true
        self.navigationController?.pushViewController(paymentVC, animated: true)
        
    }
    
    @IBAction func addDeliveryAddress(_ sender: UIButton) {
        
         if (sender.titleLabel?.text ?? "") == APPLocalize.localizestring.addAddress.localize() {
            let addNewAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SaveDeliveryLocationViewController) as! SaveDeliveryLocationViewController
            addNewAddress.delegate = self
            addNewAddress.isFromEditAddress = false
             addNewAddress.fromVC = .Current
            self.navigationController?.pushViewController(addNewAddress, animated: true)
         } else {
            selectAddress(sender)
        }
       
    }
    
    @IBAction func selectAddress(_ sender: UIButton) {
        
        let deliveryAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DeliveryLocationViewController) as! DeliveryLocationViewController
        deliveryAddress.delegate = self
        self.navigationController?.pushViewController(deliveryAddress, animated: true)
    }
    
    @IBAction func addUserDeliveryAddress(_ sender: UIButton) {
        let addNewAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SaveDeliveryLocationViewController) as! SaveDeliveryLocationViewController
        addNewAddress.delegate = self
        addNewAddress.isFromEditAddress = false
        addNewAddress.fromVC = .Current
        self.navigationController?.pushViewController(addNewAddress, animated: true)
    }
}

//MARK: UITableview Delegate & DataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
        case 1:
            return cartCount > 0 ? 1 : 0
        case 2:
            return cartCount > 0 ? cartList.count : 0
        case 3:
            return cartCount > 0 ? 1 : 0
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
            if isFromResturantCart {
                  return 60
            } else {
                return 0
            }
        case 1:
            return 70
        case 2:
            return UITableViewAutomaticDimension
        case 3:
            return 250
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
            
        case 0:
            
            if isFromResturantCart {
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.GoBackCell, for: indexPath) as! GoBackCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                if cartList.count > 0 && cartList.count > indexPath.row {
                    
                    let cartsEntity = cartList[indexPath.row]
                    
                    cell.titleLabel.text = cartsEntity.product?.shop?.name
                    cell.subTitleLabel.text = cartsEntity.product?.shop?.description
                }
                return cell
            } else {
                return UITableViewCell()
            }

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CartResturant, for: indexPath) as! CartResturant
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            if shop != nil {
                cell.shopImage.setImage(with: shop?.avatar, placeHolder: #imageLiteral(resourceName: "restaurant_placeholder"))
                cell.shopNameLbl.text = shop?.name
                cell.shopDescriptionLbl.text = shop?.description
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CartListView, for: indexPath) as! CartListView
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            if cartList.count > 0 && cartList.count > indexPath.row {
                
                let cartsEntity = cartList[indexPath.row]
                cell.itemNameLbl.text = cartsEntity.product?.name
                
                if cartsEntity.product?.food_type == VEGORNONVEG().veg {
                    cell.vegOrNonVeg.image = #imageLiteral(resourceName: "veg")
                } else {
                    cell.vegOrNonVeg.image = #imageLiteral(resourceName: "nonveg")
                }
                
                cell.customizedButton.tag = indexPath.row
                cell.customizedButton.addTarget(self, action: #selector(showAddOnsViewAppears(sender:)), for: .touchUpInside)
                
                var priceCount = [Double]()
                let price =   Double((cartsEntity.product?.prices?.orignal_price)!) * cartsEntity.quantity!

                priceCount.append(price)

                if cartsEntity.cart_addons?.count != 0 {
                    
                    for item in (cartsEntity.cart_addons)! {
                        let quantity = cartsEntity.quantity!
                        let price =  Double(item.addon_product?.price ?? 0.0) * Double(item.quantity!)
                        
                        let totalPrice = Int(price) * Int(quantity)
                        priceCount.append(Double(totalPrice))
                    }
                }
                
                let totalPriceAccount = priceCount.reduce(0, +)

                let priceAmt = String(format: " $%.02f", Double(totalPriceAccount))

                cell.priceLbl.text = priceAmt
                
                cell.cartCount.text = "\(Int(cartsEntity.quantity ?? 0.0))"//"\(Int.val(val: cartsEntity.quantity!))"
                cell.addToCart.addTarget(self, action: #selector(addItemToCart), for: .touchUpInside)
                cell.removeFromCart.addTarget(self, action: #selector(removeItemFromCart), for: .touchUpInside)
                
                var addonsNameArr = [String]()
                addonsNameArr.removeAll()

                for var i in 0..<(cartsEntity.cart_addons!.count)
                {
                    let Result = cartsEntity.cart_addons![i]
                    
                    let str = "\(Result.addon_product?.addon?.name! ?? "")"
                    
                    addonsNameArr.append(str)
                }
                
                if cartsEntity.product?.addons?.count == 0 {
                    cell.addOnsLabel.isHidden = true
                    cell.customizedView.isHidden = true
                }else{
                    if cartsEntity.cart_addons?.count == 0 {
                        cell.addOnsLabel.isHidden = false
                        cell.customizedView.isHidden = false
                        cell.addOnsLabel.text = "No Add-Ons"
                    }else{
                        cell.addOnsLabel.isHidden = false
                        cell.customizedView.isHidden = false
                        let addonsstr = addonsNameArr.joined(separator: ", ")
                        cell.addOnsLabel.text = addonsstr
                    }
                }
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CartCheckOut, for: indexPath) as! CartCheckOut
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if !notes.isEmpty {
                cell.addCustomNoteLbl.text = notes

            }
            
            if User.main.id != nil {
//                cell.walletAmountLbl.isHidden = true
//                cell.useWalletLbl.isHidden = true
//                cell.checkUnCheck.isHidden = true
//                cell.useWalletButton.isHidden = true
                
                let walletAmt = User.main.wallet_balance
                
                if walletAmt == 0{
                    cell.walletAmountLbl.isHidden = true
                    cell.useWalletLbl.isHidden = true
                    cell.checkUnCheck.isHidden = true
                    cell.useWalletButton.isHidden = true
                }else{
                    cell.walletAmountLbl.isHidden = false
                    cell.useWalletLbl.isHidden = false
                    cell.checkUnCheck.isHidden = false
                    cell.useWalletButton.isHidden = false
                    cell.useWalletLbl.text = String(format: "$ %.2f", Double(walletAmt ?? 0))
                    cell.checkUnCheck.image = UIImage(named: "uncheck")
                }
                
            }else{
                let address = DataManager.shared.getSelectedAddressDetails()
                let walletAmt = User.main.wallet_balance
                
                if walletAmt == 0{
                    cell.walletAmountLbl.isHidden = true
                    cell.useWalletLbl.isHidden = true
                    cell.checkUnCheck.isHidden = true
                    cell.useWalletButton.isHidden = true
                }else{
                    cell.walletAmountLbl.isHidden = false
                    cell.useWalletLbl.isHidden = false
                    cell.checkUnCheck.isHidden = false
                    cell.useWalletButton.isHidden = false
                    cell.useWalletLbl.text = String(format: "$%@%.2f", Double(walletAmt ?? 0))
                    cell.checkUnCheck.image = UIImage(named: "uncheck")
                }
            }
            
            cell.customNotesButton.addTarget(self, action: #selector(addCustomNotes), for: .touchUpInside)
            let totalPriceAmt = String(format: " $%.02f", Double(totalPrice))

            cell.totalItemCountLbl.text = totalPriceAmt
            if let discountP = discountPrice {
                let discountPriceDouble = Double(discountP)
                let DiscountPriceAmt = String(format: " $%.02f", Double(discountPriceDouble!))

                cell.discountAmountLbl.text = "-" + DiscountPriceAmt

            }
            if let deliveryC = deliveryCharge {
                let deliveryChargeDouble = String(format: " $%.02f", Double(deliveryC)!)

                cell.deliveryFeeAmountLbl.text = deliveryChargeDouble
            }
            cell.useWalletButton.addTarget(self, action: #selector(useWalletAmount), for: .touchUpInside)
            cell.toPayAmountLbl.text = Common.showAmount(amount: Double(needToPay))
            cell.serviceAmountLbl.text = String(format: " $%.02f", Double(serviceTax))
            
            
            let promoCodeId = UserDefaults.standard.object(forKey: "promoCodeId") as? Int ?? 0
            if promoCodeId == 0 {
                cell.applyButton.isUserInteractionEnabled = true
                cell.applyButton.setTitle(APPLocalize.localizestring.apply.localize().uppercased(), for: .normal)

            }else{
                 cell.applyButton.isUserInteractionEnabled = false
                cell.applyButton.setTitle(APPLocalize.localizestring.applied.uppercased(), for: .normal)

            }
            // Localize
            cell.totalItemTextLbl.textAlignment = selectedLanguage == .arabic ? .right : .left
            cell.totalItemCountLbl.textAlignment = selectedLanguage == .arabic ? .left : .right
            cell.deliveryFeeTextLbl.textAlignment = selectedLanguage == .arabic ? .right : .left
            cell.deliveryFeeAmountLbl.textAlignment = selectedLanguage == .arabic ? .left : .right
            cell.serviceTaxTextLbl.textAlignment = selectedLanguage == .arabic ? .right : .left
            cell.serviceAmountLbl.textAlignment = selectedLanguage == .arabic ? .left : .right
            cell.discountTextLbl.textAlignment   = selectedLanguage == .arabic ? .right : .left
            cell.discountAmountLbl.textAlignment = selectedLanguage == .arabic ? .left : .right
            
            cell.applyButton.addTarget(self, action: #selector(applyPromocodeAction), for: .touchUpInside)

            return cell
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.row, indexPath.section) {
        case (0,0):
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didReceiveAddCartUpdate(isRefreshPage: true)

        default:
            break
        }
    }
    
}


extension CartViewController {
    
   
    
    @objc func applyPromocodeAction(sender: UIButton) {
        let promo = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PromoCodeViewController) as! PromoCodeViewController
        promo.delegate = self
        self.navigationController?.pushViewController(promo, animated: true)
    }
    
    // showAddOns Alert
    @objc func showAddOnsViewAppears(sender: UIButton) {
        let buttonRow = sender.tag
        let indexPath = IndexPath.init(row: buttonRow, section: 2)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "showAddOnsViewController")as! showAddOnsViewController
        vc.cartList = self.cartList[indexPath.row]
        vc.delegate = self
        //vc.totalItemPrice = totalPrice
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func useWalletAmount(sender: UIButton) {
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? CartCheckOut {
            
            if cell.checkUnCheck.image == #imageLiteral(resourceName: "uncheck") {
                
                cell.checkUnCheck.image = #imageLiteral(resourceName: "cellSelect")
                useWallet = USE_WALLET().YES
            } else {
                
                 cell.checkUnCheck.image = #imageLiteral(resourceName: "uncheck")
                 useWallet = USE_WALLET().NO

            }
        }
    }
    
    @objc func addItemToCart(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            let cell = self.tableView.cellForRow(at: indexPath) as! CartListView

            let cartEntity = cartList[indexPath.row]
            print(cartEntity)
            self.addCart = AddCart()
            if cartEntity.product?.addons?.count != 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreAddOnsViewController")as! MoreAddOnsViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.product = cartEntity.product
                vc.cartListAddons = cartEntity.cart_addons!
                vc.isFromFeatureProduct = false
                vc.isFromCartPage = true
                vc.delegate = self
                vc.cartId = cartEntity.id ?? 0
                vc.qty = Int((cartEntity.quantity ?? 0.0) + 1.0)
                self.present(vc, animated: true, completion: nil)
            }else{
                if cartEntity.cart_addons?.count != 0 {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreAddOnsViewController")as! MoreAddOnsViewController
                    vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    vc.product = cartEntity.product
                    vc.isFromFeatureProduct = false
                    vc.delegate = self
                    vc.qty = Int((cartEntity.quantity ?? 0.0) + 1.0)
                    self.present(vc, animated: true, completion: nil)
                    
                }else{
                    self.addCart?.quantity = Int((cartEntity.quantity ?? 0.0) + 1.0)
                    self.addCart?.cart_id = cartEntity.id
                    self.addCart?.product_id = cartEntity.product_id
                    self.loader.isHidden = false
                    cell.cartCount.text = "\(Int(cartEntity.quantity! + 1))"
                    animate(cell.cartCount)
                    self.presenter?.post(api: .addCart, data: self.addCart?.toData())
                }
            }
            
        }
        
    }
    
    @objc func removeItemFromCart(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            let cell = self.tableView.cellForRow(at: indexPath) as! CartListView
            var quantityarr = [Int]()

            let cartEntity = cartList[indexPath.row]
            self.addCart = AddCart()
            if cartEntity.cart_addons?.count != 0 {
                
                
                
                for item in (cartList[indexPath.row].cart_addons)! {
                    
                    
                    let quantity = item.quantity
                    
                    quantityarr.append(Int(quantity ?? 0.0))
                }
                var productId = [Int]()
                for i in 0..<(cartList[indexPath.row].product!.addons!.count) {
                    
                    let dictItem = cartList[indexPath.row].product!.addons![i]
                    
                    productId.append(dictItem.addon?.id ?? 0)
                    
                }
                self.addCart?.product_addons = productId
                self.addCart?.addons_qty = quantityarr
            }
            self.addCart?.quantity = (Int(cartEntity.quantity ?? 0.0)) - 1
            self.addCart?.cart_id = cartEntity.id
            self.addCart?.product_id = cartEntity.product_id
            self.loader.isHidden = false
            cell.cartCount.text = "\(Int(cartEntity.quantity! + 1))"
            animate(cell.cartCount)
            self.presenter?.post(api: .addCart, data: self.addCart?.toData())
        }
    }
    
    @objc func addCustomNotes(sender: UIButton) {
        
        let customAlertViewController = CustomNotesViewController(nibName: Storyboard.Ids.CustomNotesViewController, bundle: nil)
        customAlertViewController.delegate = self
        customAlertViewController.customNote = self.notes
        customAlertViewController.modalTransitionStyle = .crossDissolve
       // customAlertViewController.providesPresentationContextTransitionStyle = true;
      //  customAlertViewController.definesPresentationContext = true;
        customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.present(customAlertViewController, animated: false, completion: nil)
    }
}

extension CartViewController: PostViewProtocol {
    
    func viewCartList() {
         self.presenter?.get(api: .addCart, data: nil)
    }
     //Callback for error
    func onError(api: Base, message: String, statusCode code: Int) {
         self.loader.isHidden = true
         shimmerView.isHidden = true
    }
    
    //Callback for addCart
    func addCart(api: Base, data: CartList?) {
        
        if api == .addCart, data != nil {
            
            if (data?.carts?.count)! > 0 {
             cartCount = (data?.carts?.count)!
             deliveryCharge = data?.delivery_charges
             taxPercent = Int((data?.tax_percentage)!) ?? 0
             cartList = (data?.carts)!
            } else {
                cartCount = 0
            }
            
            User.main.cartCount = cartCount

            if cartCount > 0 {
            
                if data?.carts?.first?.product?.shop != nil {
                    shop = data?.carts?.first?.product?.shop
                }
                
                
                totalPrice = Int((data?.total_price) ?? 0)
                
                let taxpercentage:Int = taxPercent
                let total:Int = totalPrice
                
                 //To set service tax
                let tax = Double(taxpercentage)*(0.01)
                let serviceTaxs = tax*Double(total)
                serviceTax = Int(round(serviceTaxs))
               
                //To set Discount
                if shop?.offer_min_amount ?? 0 < totalPrice {
                let discountPercent: Int = shop?.offer_percent ?? 0
                let totalDiscount =  Double(discountPercent)*(0.01)
                let discountAmount = totalDiscount * Double(total)
                let roundedDiscount =  String(format: "%.2f", discountAmount)
                
                discountPrice = roundedDiscount
                
                } else {
                     discountPrice = "0"
                }

                let payTo = data?.net ?? 0.0

                
                needToPay = payTo
                tableView.reloadData()
                self.tableView.backgroundView = nil
                addressView.isHidden = false
            } else {
                addressView.isHidden = true
                tableView.reloadData()
                self.tableView.setBackgroundImageAndTitle(imageName: EmptyImage.cartEmpty.rawValue, title: APPLocalize.localizestring.goodFoodIsAlwaysGettingCooked.localize(), description: APPLocalize.localizestring.pleaseOrderDish.localize())
            }
        }
        
        
        if  User.main.cart != nil {
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = nil
               
            }
        }
      self.loader.isHidden = true
      shimmerView.isHidden = true
    }
}

// MARK: - Convert Int value to float value
extension String {
    var intValue: Int {
        return (self as NSString).integerValue
    }
}

// MARK: - ManageAddressDelegate
extension CartViewController: ManageAddressDelegate {
    
    func didReceiveManageAddress(isUpdated: Bool?, address: String?, deliveryType: String?, addressId: Int?) {
        self.setAddressViewDetails()
        self.addressId = addressId ?? 0


       /* if isUpdated == true {
            locationLbl.text = deliveryType
            addressLbl.text = address
            self.addressId = addressId ?? 0
            
            if deliveryType == Constants.string.work.lowercased().localize() {
                
                locationTypeImgView.image = #imageLiteral(resourceName: "workUnselected")
                
            } else if deliveryType == Constants.string.home.lowercased().localize() {
                locationTypeImgView.image = UIImage(named: "ic_home_unselect")//#imageLiteral(resourceName: "homeUnselected")
            } else {
                locationTypeImgView.image = UIImage(named: "ic_location_unselect")// #imageLiteral(resourceName: "otherUnselected")
            }
            
            addressAddView.isHidden = true
            addAdressBut.isHidden = false
        }*/
    }

}


// MARK:- ManageAddressDelegate

extension CartViewController: SavedAddressDelegate {
    
    func didReceiveSavedAddress(isUpdated: Bool?, addressDetails: UserAddressDetails?) {
        
        self.setAddressViewDetails()
        addressId = addressDetails?.id ?? 0

     /*   if isUpdated == true {
            locationLbl.text = addressDetails?.type
            addressLbl.text = addressDetails?.map_address
            addressId = addressDetails?.id ?? 0
         
            let deliveryType: String
                = addressDetails?.type ?? Constants.string.empty
            if deliveryType == Constants.string.work.lowercased().localize() {
                
                locationTypeImgView.image = #imageLiteral(resourceName: "workUnselected")
                
            } else if deliveryType == Constants.string.home.lowercased().localize() {
                
                locationTypeImgView.image = UIImage(named: "ic_home_unselect")// #imageLiteral(resourceName: "homeUnselected")
            } else {
                
                locationTypeImgView.image = UIImage(named: "ic_location_unselect") // #imageLiteral(resourceName: "otherUnselected")
            }
            
            addressAddView.isHidden = true
            addAdressBut.isHidden = false
        } */
    }
}


//MARK: - Location Manager & CLLocationManagerDelegate

extension CartViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentLocation.longitude = (location?.coordinate.longitude)!
        currentLocation.latitude = (location?.coordinate.latitude)!
        
        let locations = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let geoCoder = CLGeocoder()
         geoCoder.reverseGeocodeLocation(locations, completionHandler: {(placemarks, error) in
            if (error != nil) {
                
            }
        
            if (Reachability()?.connection != .none) {
                let placemark = placemarks! as [CLPlacemark]
                
                if placemark.count > 0 {
                    let placemark = placemarks![0]

                    if placemark.subLocality != nil {
                        self.locationLbl.text = placemark.subLocality
                    }
                    
                    if let dict: NSDictionary =   placemark.addressDictionary! as NSDictionary {
                    let formattedAddressLines: [String] =  dict.value(forKey: "FormattedAddressLines") as! [String]
                    let currentAddress = formattedAddressLines.joined(separator: ", ")
                    
                     self.addressLbl.text = currentAddress
                     
                    }
                }
            } })
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension CartViewController: AddAddressDelegate {
    
    func didReceiveAddAddress(isUpdated: Bool?, addressDetails: UserAddressDetails?) {
        
        self.setAddressViewDetails()
      /*  return
        if isUpdated == true {
            locationLbl.text = addressDetails?.type
            addressLbl.text = addressDetails?.map_address
            addressId = addressDetails?.id ?? 0
            let deliveryType: String
                = addressDetails?.type ?? Constants.string.empty
            if deliveryType == Constants.string.work.lowercased().localize() {
                
                locationTypeImgView.image = #imageLiteral(resourceName: "workUnselected")
                
            } else if deliveryType == Constants.string.home.lowercased().localize() {
                locationTypeImgView.image = UIImage(named: "ic_home_unselect")// #imageLiteral(resourceName: "homeUnselected")
            } else {
                locationTypeImgView.image = UIImage(named: "ic_location_unselect")
                // #imageLiteral(resourceName: "otherUnselected")
            }
            
            addressAddView.isHidden = true
            addAdressBut.isHidden = false
        }*/

    }
    
}


extension CartViewController: CustomNotesDelegate {
    
    func didReceiveCustomNotes(isNoteAdded: Bool?, customNotes: String?) {
        
        if customNotes?.isEmpty ?? true {
            
           notes = Constants.string.empty
        } else {
            
           notes = customNotes!
        }
        self.tableView.reloadData()
    }

}
extension CartViewController: CartUpdateDelegate {
    func didReceiveAddCartUpdate() {
        viewCartList()
    }
}
extension CartViewController: promoCodeApplyDelegate {
    func setPromoApply(isValue: Bool) {
        isPromoCodeApplied = isValue
        tableView.reloadData()
        
    }
    
    
}
extension CartViewController: AddCartUpdateDelegate{
    func didReceiveAddCartUpdate(isRefreshPage: Bool?) {
        if isRefreshPage! {
            self.loader.isHidden = false
            viewCartList()

        }
    }
    
    
}
extension CartViewController: MoreAddOnsViewControllerDelegate{
    
    
    func chooseProductCartItemAction(product: Products) {
        let menuVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddOnsViewController) as! AddOnsViewController
        menuVC.isFromFeaturedProducts = false
        menuVC.productDict = product
        menuVC.delegate = self
        //  menuVC.cartList = productEntity.cart?[index]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

        self.navigationController?.pushViewController(menuVC, animated: true)
        }
    }
    
    func chooseFeatureProductCartItemAction(featureProduct: Featured_products) {
        
    }
    
    func repeatProduct(product: Products, addOnsArr: NSMutableArray, qty: Int, cartId: Int) {

        
        self.addCart = AddCart()
        self.addCart?.quantity = qty 
        self.addCart?.cart_id = cartId
        self.addCart?.product_id = product.id
    
        
        var productId = [Int]()
        var qtyArr = [Int]()
        for i in 0..<addOnsArr.count {
            
            let Result = addOnsArr[i] as! NSDictionary
            let addOnsID = Result.value(forKey: "id") as? Int ?? 0
            let quantity = Result.value(forKey: "qty") as? Int ?? 0
            print(addOnsID)
            
            qtyArr.append(quantity)
            productId.append(addOnsID)
        }
        self.addCart?.product_addons = productId
        self.addCart?.addons_qty = qtyArr
        
        print(addCart as Any)
        loader.isHidden = false
        self.presenter?.post(api: .addCart, data: self.addCart?.toData())
    }
    
    func repeatFeatureProduct(featureProduct: Featured_products, addOnsArr: NSMutableArray) {
        
    }
    
    
}
extension CartViewController: showDatePickerVCDelegate {
    func doneAction(isschedule: Bool,isscheduleDate: String,notes: String,useWallet: Int,addressId: Int) {
        let paymentVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PamentListViewController) as! PamentListViewController
        paymentVC.addressId = addressId
        paymentVC.notes = notes
        paymentVC.useWallet = useWallet
        paymentVC.isFromCartFlow = true
        paymentVC.scheduleDate = isscheduleDate
        paymentVC.isscheduleValue = isschedule
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

        self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    
}
