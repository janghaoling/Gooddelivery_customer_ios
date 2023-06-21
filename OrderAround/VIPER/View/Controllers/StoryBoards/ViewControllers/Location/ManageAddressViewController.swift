//
//  ManageAddressViewController.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class ManageAddressViewController: UIViewController {
    
    //MARK: - Declarations.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var manageAddressLbl: UILabel!
    var headerHeight: CGFloat = 55
    var footerHeight: CGFloat = 60
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    @IBOutlet weak var descriptionLbl: UILabel!
    var userAddressDetails = [UserAddressDetails]()
    var deleteId: Int?
    @IBOutlet weak var knockLbl: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var emptyAddressView: UIView!
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserAddress()
        localize()
        tableView.register(UINib(nibName: XIB.Names.AddressManageCell, bundle: nil), forCellReuseIdentifier: XIB.Names.AddressManageCell)
        tableView.register(UINib(nibName: XIB.Names.AddNewAddressCell, bundle: nil), forCellReuseIdentifier: XIB.Names.AddNewAddressCell)
        tableView.separatorStyle = .none
        addressButton.addTarget(self, action: #selector(addNewAdressForDelivery), for: .touchUpInside)
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
}

//MARK: String Localization & Button actions
extension ManageAddressViewController {
    
    private func localize() {
        
        manageAddressLbl.text = APPLocalize.localizestring.manageAdress.localize()
        knockLbl.text = APPLocalize.localizestring.knockText.localize()
        descriptionLbl.text = APPLocalize.localizestring.knockDescription.localize()
        Common.setFont(to: manageAddressLbl, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: knockLbl, isTitle: true, size: 16, fontType: .semiBold)
        Common.setFont(to: descriptionLbl, isTitle: true, size: 14, fontType: .semiBold)
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource
extension ManageAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAddressDetails.count > 0 ? userAddressDetails.count : 0
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 100
//    }
    
    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
       
        return headerHeight
       
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddNewAddressCell) as! AddNewAddressCell
        cell.addNewAddress.addTarget(self, action: #selector(addNewAdressForDelivery), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
         return tableView.frame.size.width * 0.18//footerHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
            headerView.backgroundColor = UIColor(hex: "#F6F6F6")
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 20, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
            headerLbl.text = APPLocalize.localizestring.savedAddress.localize()
            Common.setFont(to: headerLbl, size : 16, fontType : FontCustom.semiBold)
            headerLbl.textColor = UIColor.black
            headerLbl.textAlignment = .left
            headerView.addSubview(headerLbl)
            return headerView
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddressManageCell, for: indexPath) as! AddressManageCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if userAddressDetails.count > indexPath.row {
            
            let userDetails = userAddressDetails[indexPath.row]
            let type: String = userDetails.type ?? ""
            if type == APPLocalize.localizestring.work.localize().lowercased() {
                
                cell.typeImg.image = #imageLiteral(resourceName: "workUnselected")
                
            } else if type == APPLocalize.localizestring.home.localize().lowercased() {
                cell.typeImg.image = UIImage(named: "ic_home_unselect")// #imageLiteral(resourceName: "homeUnselected")
            } else {
                cell.typeImg.image = UIImage(named: "ic_location_unselect")// #imageLiteral(resourceName: "otherUnselected")
            }
            cell.addressLbl.text = userDetails.map_address
            cell.typeName.text = userDetails.type?.uppercased()
            cell.editAddress.tag = indexPath.row
            cell.deleteAddress.tag = indexPath.row
            cell.editAddress.addTarget(self, action: #selector(editUserAddress), for: .touchUpInside)
            cell.deleteAddress.addTarget(self, action:  #selector(deleteUserAddress), for: .touchUpInside)
        }
        
        return cell
        
    }
    


}

//MARK: Button Actions.
extension ManageAddressViewController {
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
    @objc func addNewAdressForDelivery(sender: UIButton) {
       
        let addNewAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SaveDeliveryLocationViewController) as! SaveDeliveryLocationViewController
        addNewAddress.delegate = self
        addNewAddress.isFromEditAddress = false
        addNewAddress.fromVC = .AddNew
        self.navigationController?.pushViewController(addNewAddress, animated: true)
    }
}

//MARK: PostViewProtocol
extension ManageAddressViewController: PostViewProtocol {
    
    func getUserAddress() {
        
        self.loader.isHidden = false
        self.presenter?.get(api: .userAddress, data: nil)
    }
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
        self.showToast(string: message)
    }
    
    func getAddress(api: Base, data: [UserAddressDetails]?, msg: Message?) {
        
        if api == .userAddress, data != nil {
            self.loader.isHidden = true
            if data?.count ?? 0 > 0 {
                emptyAddressView.isHidden = true
                userAddressDetails = data ?? []
            } else {
               emptyAddressView.isHidden = false
            }
            
        }
        
        
        if api == .userAddress, msg != nil {
            
            self.loader.isHidden = true
            self.getUserAddress()
            
        }
        
       tableView.reloadData()
    }

}

extension ManageAddressViewController {
    
    @objc func editUserAddress(sender: UIButton) {
        
        let userDetails = userAddressDetails[sender.tag]
        let editAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SaveDeliveryLocationViewController) as! SaveDeliveryLocationViewController
        editAddress.isFromEditAddress = true
        editAddress.fromVC = .Edit
        editAddress.delegate = self
        editAddress.userAddressDetails = userDetails
        self.navigationController?.pushViewController(editAddress, animated: true)
    }
    
    @objc func deleteUserAddress(sender: UIButton) {
        
        let userDetails = userAddressDetails[sender.tag]
        deleteId = userDetails.id
        alertControllerPresentEvent()
    }
}


//MARK: - Alert controller present event.
extension ManageAddressViewController {
    
    func alertControllerPresentEvent() {
        
        let alert = UIAlertController(title: Constants.string.empty.localize(), message: APPLocalize.localizestring.deleteAddress.localize(), preferredStyle:  UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: APPLocalize.localizestring.delet.localize(), style: .default, handler: { action in
            self.deleteTheAddress()
        }))
        
        alert.addAction(UIAlertAction(title: APPLocalize.localizestring.Cancel.localize(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Button Actions.
    
    func deleteTheAddress() {
       
        guard deleteId != nil else {
            return
        }
        self.loader.isHidden = false
        self.presenter?.delete(api: .userAddress, url: Base.userAddress.rawValue + "/" + String(describing: deleteId!), data: nil)
    }
}


extension ManageAddressViewController: ManageAddressDelegate {
    func didReceiveManageAddress(isUpdated: Bool?, address: String?, deliveryType: String?, addressId: Int?) {
        if isUpdated == true {
            getUserAddress()
        }
    }
}
