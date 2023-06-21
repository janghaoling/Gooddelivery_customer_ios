//
//  AddAmountViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddAmountViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    var cardList = [Card]()
    var headerHeight: CGFloat = 55
    var enterAmountVal = ""
    var cardNumber = 0
    var isCardSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = APPLocalize.localizestring.addAmount.localize()
        payButton.setTitle(APPLocalize.localizestring.pay.localize().uppercased(), for: .normal)
        tableView.register(UINib(nibName: XIB.Names.UserMenu, bundle: nil), forCellReuseIdentifier: XIB.Names.UserMenu)
        tableView.register(UINib(nibName: XIB.Names.AddWalletAmount, bundle: nil), forCellReuseIdentifier: XIB.Names.AddWalletAmount)
        tableView.separatorStyle = .none
        getUserCardList()
    }
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payClickEvent(_ sender: UIButton) {
        
        var addAmountData = AddAmountEntity()
        
        if enterAmountVal == "" {
            
            self.showToast(string: ErrorMessage.list.enterAmountErr.localize())
            
        } else if cardNumber == 0 {
            
            self.showToast(string: ErrorMessage.list.cardNumber.localize())
            
        } else {
            self.loader.isHidden = false
            if enterAmountVal.contains("$"){
                enterAmountVal.remove(at: enterAmountVal.startIndex)
            }
            let amtValue = Int(enterAmountVal)
            print(amtValue as Any)
            addAmountData.amount = amtValue
            addAmountData.card_id = cardNumber
            self.presenter?.post(api: .addAmount, data: addAmountData.toData())
        }
        
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource

extension AddAmountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return cardList.count + 1
        case 1:
            return 1
        
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
            return 70
        default:
            return 0
        }
    }
    
    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return headerHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            
        case 0:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
            headerView.backgroundColor = UIColor(hex: "#F6F6F6")
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 20, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
            headerLbl.text = APPLocalize.localizestring.paymentOption.localize()
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
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.UserMenu, for: indexPath) as! UserMenu
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.footerView.isHidden = true
            cell.headerView.isHidden = true

            //first get total rows in that section by current indexPath.
            let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == totalRows - 1 {
                
                cell.headerIcon.image = #imageLiteral(resourceName: "promotion")
                cell.titleLbl.text = APPLocalize.localizestring.promoDetails.localize().capitalized
                cell.footerIcon.isHidden = true
                cell.hiddenButton.isHidden = true
                
            } else {
                let cartDetail = cardList[indexPath.row]
                cell.headerIcon.image = #imageLiteral(resourceName: "debit-card")
                cell.titleLbl.text = "XXXX-XXXX-XXXX-" + cartDetail.last_four!
                cell.footerIcon.image = UIImage.init(named: "FilterUnSelectedIcon")
                cell.hiddenButton.isHidden = true
                cell.footerIcon.isHidden = false

            }
            
             return cell
           
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddWalletAmount, for: indexPath) as! AddWalletAmount
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddWalletAmount, for: indexPath) as! AddWalletAmount
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.delegate = self
            return cell
        }
        
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.UserMenu, for: indexPath) as! UserMenu
//
//        let dictVal = cardArray[indexPath.row] as? [AnyHashable : Any]
//        let card = dictVal?["brand"] as? String
//        if (card == "PROMO") {
//            let promoVC = storyboard.instantiateViewController(withIdentifier: "PromoCodeViewController") as? PromoCodeViewController
//            promoVC?.fromString = "PAYMENT"
//            if let promoVC = promoVC {
//                navigationController?.pushViewController(promoVC, animated: true)
//            }
//        } else {
//            if let value = dictVal?["id"] {
//                card_id = "\(value)"
//            }
//            cell?.checkImg.image = UIImage(named: "cellSelect")
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let cell = tableView.cellForRow(at: indexPath) as! UserMenu
            
            if isCardSelected {
                isCardSelected = false
                cell.footerIcon.image = UIImage.init(named: "FilterSelectedIcon")
                if cardList.count>0{
                    let cartDetail = cardList[indexPath.row]
                    cardNumber = cartDetail.cardid ?? 0
                }
            }else{
                isCardSelected = true
                cell.footerIcon.image = UIImage.init(named: "FilterUnSelectedIcon")
                cardNumber = 0
            }
            
            cell.hiddenButton.isHidden = true
            cell.footerIcon.isHidden = false
           
        case (1,totalRows-1):
            
            let promo = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PromoCodeViewController) as! PromoCodeViewController
            self.navigationController?.pushViewController(promo, animated: true)
        default:
            break
        }
    }
    
}

extension AddAmountViewController: AddAmountViewControllerDelegate {
    
    func showEnterAmount(enterAmountValue: String) {
        enterAmountVal = enterAmountValue
    }    
}

//MARK:- user/card API

extension AddAmountViewController: PostViewProtocol {
    
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
        self.loader.isHidden = true
        cardList = data ?? []
        tableView.reloadData()
    }
    
    func getAddAmount(api: Base, data: AddAmountEntity?) {
        self.loader.isHidden = true
       self.navigationController?.popViewController(animated: true)
    }
    
}






