//
//  WalletListViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class WalletListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cardList = [1,2,3]
    var headerHeight: CGFloat = 55
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var walletHistoryDataSource:[WalletModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = APPLocalize.localizestring.wallet.localize().uppercased()
        addButton.setTitle(APPLocalize.localizestring.add.localize(), for: .normal)
        tableView.register(UINib(nibName: XIB.Names.UserMenu, bundle: nil), forCellReuseIdentifier: XIB.Names.UserMenu)
        tableView.register(UINib(nibName: XIB.Names.WalletHistory, bundle: nil), forCellReuseIdentifier: XIB.Names.WalletHistory)
        tableView.separatorStyle = .none
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWalletHistory()
    }
    
    @IBAction func addAmountToWallet(_ sender: UIButton) {
        let addAmountToWallet = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddAmountViewController) as! AddAmountViewController
        self.navigationController?.pushViewController(addAmountToWallet, animated: true)
    }
    

    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource

extension WalletListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return walletHistoryDataSource.count //cardList.count + 1
            
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = walletHistoryDataSource else { return 1 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 55
        case 1:
            return 60
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
            
        case 1:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
            headerView.backgroundColor = UIColor(hex: "#F6F6F6")
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 20, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
            headerLbl.text = APPLocalize.localizestring.History.localize()
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
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.UserMenu, for: indexPath) as! UserMenu
//            cell.selectionStyle = .none
//            cell.backgroundColor = .clear
//            cell.widthConstraint.constant = 0
//            cell.footerIcon.isHidden = true
//            cell.hiddenButton.setTitle("$12", for: .normal)
//            let walletAmt = User.main.wallet_balance
//            cell.setWalletDetails(title: "Wallet Amount", status: "", amount: "\(walletAmt ?? 0)")
//            cell.headerView.isHidden = true
//            cell.footerView.isHidden = true
//            return cell
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletHistory, for: indexPath) as! WalletHistory
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
             let walletAmt = User.main.wallet_balance
            cell.setWalletDetails(title: APPLocalize.localizestring.walletAmount.localize(), status: "", amount: "\(Double(walletAmt ?? 0) )")
            cell.statusLabel.isHidden = true
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletHistory, for: indexPath) as! WalletHistory
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            let wallet = walletHistoryDataSource[indexPath.row]
            let dateDetails = convertExpectDateFoemat(date: wallet.created_at ?? "")
            cell.setWalletDetails(title: dateDetails, status: wallet.status ?? "", amount: "\(Double(wallet.amount ?? "0") ?? 0.0)")
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletHistory, for: indexPath) as! WalletHistory
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
           
            return cell
        }
        
        
    }
    func convertExpectDateFoemat(date:String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = DateFormat.list.yyyy_mm_dd_HH_MM_ss//"yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = DateFormat.list.WalletHistoryFormat
        
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
            
        }
            return dateFormatterPrint.string(from: Date())

    }
}


extension WalletListViewController:PostViewProtocol {
    
    func getWalletHistory(){
          LoadingIndicator.show()
         self.presenter?.get(api: .walletHistory, data: nil)
    }
    
    func onError(api: Base, message: String, statusCode code: Int) {
        Common.showToast(string: message)
    }
    
    func getWalletHistory(api: Base, data: [WalletModel]?) {
         LoadingIndicator.hide()
        if let responseData = data,api == .walletHistory {
            self.walletHistoryDataSource = responseData
            
            var TotalAmount = [Int]()
            TotalAmount.removeAll()
            for i in 0..<self.walletHistoryDataSource.count {
                
                let Result = self.walletHistoryDataSource[i]
                TotalAmount.append(Int(Result.amount!) ?? 0)
            }
            User.main.wallet_balance = TotalAmount.reduce(0, +)

            print(walletHistoryDataSource)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
