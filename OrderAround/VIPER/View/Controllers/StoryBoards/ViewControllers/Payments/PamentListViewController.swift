//
//  PamentListViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

struct TOCHECK_POSTORDELETE_METHOD {
    
    let POST = "POST"
    let DELETE = "DELETE"
}

struct PAYMENT_MODE:Codable {
    
    let STRIPE = "STRIPE"
    let CASH = "CASH"
}

class PamentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var proceedToPayView: UIView!
    @IBOutlet weak var proceedToPayButton: UIButton!
    
    var cardList = [Card]()
    var headerHeight: CGFloat = 55
    var notes = String()
    var useWallet = Int()
    var addressId = Int()
    var cartId = Int()
    var paymentMode = String()
    var isFromCartFlow = false
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    var isFromGetList = String()
    var selectedCart = Int()
    var userOrderCheckOutInfo: UserOrderCheckOutInfo?
    var isscheduleValue = false
    var scheduleDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = APPLocalize.localizestring.payment.localize()
        
        tableView.register(UINib(nibName: XIB.Names.UserMenu, bundle: nil), forCellReuseIdentifier: XIB.Names.UserMenu)
        tableView.register(UINib(nibName: XIB.Names.AddWalletAmount, bundle: nil), forCellReuseIdentifier: XIB.Names.AddWalletAmount)
        tableView.separatorStyle = .none
        getUserCardList()
        if !isFromCartFlow {
            proceedToPayButton.isHidden = true
        }else{
            proceedToPayButton.isHidden = false

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: UITableViewDelegate & UITableViewDataSource

extension PamentListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
           return cardList.count + 1
            
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 55
        case 1:
            return 55
        default:
            return 0
        }
    }
    
    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return headerHeight
        case 1:
            return headerHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            
        case 0:
            
            if isFromCartFlow {
                let headerView = UIView()
                headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
                headerView.backgroundColor = UIColor(hex: "#F6F6F6")
                let headerLbl = UILabel()
                headerLbl.frame = CGRect(x: 20, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
                headerLbl.text = APPLocalize.localizestring.payOnDelivery.localize()
                Common.setFont(to: headerLbl, size : 14, fontType : FontCustom.semiBold)
                headerLbl.textColor = UIColor.lightGray
                headerLbl.textAlignment = .left
                headerView.addSubview(headerLbl)
                return headerView
            } else {
                let headerView = UIView()
                headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
                headerView.backgroundColor = UIColor(hex: "#F6F6F6")
                let headerLbl = UILabel()
                headerLbl.frame = CGRect(x: 20, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
                headerLbl.text = APPLocalize.localizestring.wallet.localize()
                Common.setFont(to: headerLbl, size : 14, fontType : FontCustom.semiBold)
                headerLbl.textColor = UIColor.lightGray
                headerLbl.textAlignment = .left
                headerView.addSubview(headerLbl)
                return headerView
            }
            
            
        case 1:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
            headerView.backgroundColor = UIColor(hex: "#F6F6F6")
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 20, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
            headerLbl.text = APPLocalize.localizestring.card.localize()
            Common.setFont(to: headerLbl, size : 14, fontType : FontCustom.semiBold)
            headerLbl.textColor = UIColor.lightGray
            headerLbl.textAlignment = .left
            headerView.addSubview(headerLbl)
            return headerView
            
        default:
            let headerView = UIView()
            return headerView
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.UserMenu, for: indexPath) as! UserMenu
        switch indexPath.section {
            
        case 0:
            if isFromCartFlow {
               
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.headerIcon.image = #imageLiteral(resourceName: "cash")
                cell.titleLbl.text = APPLocalize.localizestring.cash.localize()
                cell.hiddenButton.setTitle(APPLocalize.localizestring.empty.localize(), for: .normal)
                cell.hiddenButton.addTarget(self, action: #selector(proceedToCheckout), for: .touchUpInside)
                cell.hiddenButton.tag = 9999
                
                if selectedCart == 9999 {
                    cell.footerIcon.image  = #imageLiteral(resourceName: "checked")
                } else {
                    cell.footerIcon.image  = #imageLiteral(resourceName: "cellUnselect")
                }
                
                return cell
            } else {
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                 cell.titleLbl.text = APPLocalize.localizestring.wallet.localize()
                cell.widthConstraint.constant = 0
                cell.footerIcon.isHidden = true
                 let walletAmt = User.main.wallet_balance
                cell.hiddenButton.setTitle("$\(Double(walletAmt ?? 0) )", for: .normal)
                return cell
            }
            
        case 1:
            
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.footerIcon.isHidden = true
            cell.hiddenButton.setTitle(APPLocalize.localizestring.delete.localize(), for: .normal)
           
            //first get total rows in that section by current indexPath.
            let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == totalRows - 1 {
                cell.headerIcon.image = #imageLiteral(resourceName: "Add")
                cell.titleLbl.text = APPLocalize.localizestring.addCard.localize()
                cell.titleLbl.textColor = .secondary
                cell.hiddenButton.isHidden = true
                
            } else {
                
                if cardList.count > 0 && cardList.count > indexPath.row {
                    
                    let cartDetail = cardList[indexPath.row]
                    cell.titleLbl.text = "XXXX-XXXX-XXXX-" + cartDetail.last_four!
                    cell.headerIcon.image = #imageLiteral(resourceName: "debit-card")
                    if isFromCartFlow {
                        cell.hiddenButton.isHidden = false
                        cell.hiddenButton.tag = indexPath.row
                        cell.hiddenButton.setTitle("", for: .normal)
                        cell.hiddenButton.addTarget(self, action: #selector(proceedToCheckout), for: .touchUpInside)
                        
                        cell.footerIcon.isHidden = false
                        cell.hiddenButton.tag = indexPath.row
                        
                        if selectedCart ==  cartDetail.cardid {
                            cell.footerIcon.image  = #imageLiteral(resourceName: "checked")
                        } else {
                            cell.footerIcon.image  = #imageLiteral(resourceName: "cellUnselect")
                        }
                        
                    } else {
                        cell.hiddenButton.isHidden = false
                        cell.footerIcon.isHidden = true
                        cell.hiddenButton.setTitle(APPLocalize.localizestring.delete.localize(), for: .normal)
                        cell.hiddenButton.tag = indexPath.row
                        cell.hiddenButton.addTarget(self, action: #selector(deleteTheCard), for: .touchUpInside)
                    }
        
                }
                
                cell.titleLbl.textColor = .black
                cell.footerView.isHidden = true
            }
             return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddWalletAmount, for: indexPath) as! AddWalletAmount
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            return cell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
              if !isFromCartFlow {
            let walletList = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WalletListViewController) as! WalletListViewController
            self.navigationController?.pushViewController(walletList, animated: true)
            }
        
        case (1,totalRows-1):
            let addNewCard = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddNewCardViewController) as! AddNewCardViewController
            addNewCard.delegate = self
            self.navigationController?.pushViewController(addNewCard, animated: true)
            
        default:
            break
            }
            
    }
}


extension PamentListViewController {
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
    @objc func proceedToCheckout(sender: UIButton) {
       
        
        let point = sender.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            
            if indexPath.section == 0 {
                paymentMode = PAYMENT_MODE().CASH
                selectedCart = 9999
                tableView.reloadData()

            } else {
                
                let totalRows = tableView.numberOfRows(inSection: indexPath.section)
                if indexPath.row != totalRows - 1 {
                    paymentMode = PAYMENT_MODE().STRIPE
                    let cartDetail = cardList[indexPath.row]
                    selectedCart = cartDetail.cardid!
                    cartId = selectedCart
                    tableView.reloadData()
                }
                
            }
        }
    }
    
    
    @objc func deleteTheCard(sender: UIButton) {
        
         let cartDetail = cardList[sender.tag]
         self.loader.isHidden = false
         self.presenter?.delete(api: .cardDetail, url: Base.cardDetail.rawValue + "/" + "\(cartDetail.cardid!)", data: nil)
         isFromGetList = TOCHECK_POSTORDELETE_METHOD().DELETE
    }
    
    
    @IBAction func moveToCheckPOut(_ sender: UIButton) {
      print(paymentMode)
        let promoCodeId = UserDefaults.standard.object(forKey: "promoCodeId") as? Int ?? 0

        if paymentMode == PAYMENT_MODE().CASH {
            self.loader.isHidden = false
            self.userOrderCheckOutInfo = UserOrderCheckOutInfo()
            self.userOrderCheckOutInfo?.payment_mode = paymentMode
            self.userOrderCheckOutInfo?.note = self.notes
            self.userOrderCheckOutInfo?.user_address_id = self.addressId
            self.userOrderCheckOutInfo?.wallet = self.useWallet
            if promoCodeId != 0 {
                self.userOrderCheckOutInfo?.promocode_id =  promoCodeId

            }
            if isscheduleValue {
                self.userOrderCheckOutInfo?.delivery_date = scheduleDate
            }
            self.presenter?.post(api: .order, data: self.userOrderCheckOutInfo?.toData())
            
        } else if paymentMode == PAYMENT_MODE().STRIPE{
            self.loader.isHidden = false
            self.userOrderCheckOutInfo = UserOrderCheckOutInfo()
            self.userOrderCheckOutInfo?.payment_mode = paymentMode
            self.userOrderCheckOutInfo?.note = self.notes
            self.userOrderCheckOutInfo?.user_address_id = self.addressId
            self.userOrderCheckOutInfo?.wallet = self.useWallet
            self.userOrderCheckOutInfo?.card_id = self.cartId
            if promoCodeId != 0 {
                self.userOrderCheckOutInfo?.promocode_id =  promoCodeId
                
            }
            if isscheduleValue {
                self.userOrderCheckOutInfo?.delivery_date = scheduleDate
            }
            self.presenter?.post(api: .order, data: self.userOrderCheckOutInfo?.toData())
            
        }else{
            self.showToast(string: "Please Select the Payment Mode")

        }
        
    }
    
   
}


extension PamentListViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
        self.showToast(string: message)
    }
    
    
    func getUserCardList() {
        self.loader.isHidden = false
        self.presenter?.get(api: .cardDetail, data: nil)
    }
    
    func getCardDetails(api: Base, data: [Card]?, msg: Message?) {
        print(data)
        if api == .cardDetail, data != nil {
            
             self.loader.isHidden = true
             cardList = data ?? []
        }
        
        if api == .cardDetail, msg != nil {
             self.loader.isHidden = true
        }
        
        
        if isFromGetList == TOCHECK_POSTORDELETE_METHOD().DELETE {
            isFromGetList = TOCHECK_POSTORDELETE_METHOD().POST
            getUserCardList()
            
        }
        
        self.loader.isHidden = true

        tableView.reloadData()
        
    }
    func getOrders(api: Base, data: OrderList?) {
        self.loader.isHidden = true
        let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.OrderTrackingViewController) as! OrderTrackingViewController
        vc.orderDetails = data
        vc.isPastOrder = false
        vc.isFromMyOrder = false
        let userDefaults = UserDefaults.standard
        userDefaults.set(0, forKey: "promoCodeId")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}



extension PamentListViewController: CardDetailDelegate {
    func didReceiveCartDetail(isUpdate: Bool?, cartDetail: Card?) {
        
        if isUpdate == true {
            
            getUserCardList()
        }
    }
    
}

