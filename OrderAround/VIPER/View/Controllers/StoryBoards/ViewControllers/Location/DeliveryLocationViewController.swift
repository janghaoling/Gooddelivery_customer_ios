//
//  DeliveryLocationViewController.swift
//  Project
//
//  Created by CSS on 18/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import CoreLocation


class DeliveryLocationViewController: UIViewController {

    @IBOutlet weak var setDeliveryLocationLbl: UILabel!
    @IBOutlet weak var searchAreaLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gpsLbl: UILabel!
    
    private var placesHelper : GooglePlacesHelper?
 
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
   var delegate : SavedAddressDelegate?
   var userAddressDetails = [UserAddressDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        getUserAddress()
        addGestureTo(sView: searchAreaLbl)
        initMaps()

    }
    
    private func initMaps() {
        
        if self.placesHelper == nil {
            self.placesHelper = GooglePlacesHelper()
        }
        
    }
    
    @IBAction func redirectToSaveDeliveryLocation(_ sender: UIButton) {
        
        let saveAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SaveDeliveryLocationViewController) as!  SaveDeliveryLocationViewController
        saveAddress.delegate = self  
        saveAddress.isFromEditAddress = false
        saveAddress.fromVC = .Current
        self.navigationController?.pushViewController(saveAddress, animated: true)
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.delegate?.didReceiveSavedAddress(isUpdated: false, addressDetails: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func addGestureTo(sView:UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapLocation(sender:)))
        sView.isUserInteractionEnabled = true
        sView.addGestureRecognizer(tap)
    }
    @objc func handleTapLocation(sender: UITapGestureRecognizer? = nil) {
        // handling code
        presentSearchLocationVC()
    }
    
    func presentSearchLocationVC() {
        placesHelper?.getGoogleAutoComplete { (place) in
            self.navigateToMapView(location: place.coordinate)
        }
    }
    
    func navigateToMapView(location:CLLocationCoordinate2D) {
        let saveAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SaveDeliveryLocationViewController) as!  SaveDeliveryLocationViewController
        saveAddress.delegate = self
        saveAddress.isFromEditAddress = false
        saveAddress.currentLocation = location
        saveAddress.fromVC = .Save
        self.navigationController?.pushViewController(saveAddress, animated: true)
    }
   
}


//MARK:- Methods
extension DeliveryLocationViewController {
    func initialLoads()  {
        tableView.register(UINib(nibName: XIB.Names.SavedLocation, bundle: nil), forCellReuseIdentifier: XIB.Names.SavedLocation)
        tableView.separatorStyle = .none
    }
    
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
}


//MARK:- Tableview
extension DeliveryLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userAddressDetails.count > 0 ? userAddressDetails.count : 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SavedLocation, for: indexPath) as! SavedLocation
        
        if userAddressDetails.count > 0 && userAddressDetails.count > indexPath.row {
            let userProfile = userAddressDetails[indexPath.row]
            cell.lblAddress.text = userProfile.map_address
            cell.lblLocationType.text = userProfile.type?.uppercased()
            
            let type: String = userProfile.type ?? ""
            if type ==  APPLocalize.localizestring.work.localize().lowercased() {
                
                cell.type.image = #imageLiteral(resourceName: "workUnselected")
                
            } else if type ==  APPLocalize.localizestring.home.localize().lowercased() {
                cell.type.image = UIImage(named: "ic_home_unselect") // #imageLiteral(resourceName: "homeUnselected")
            } else {
                cell.type.image = UIImage(named: "ic_location_unselect")
            }
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userAddressDetails.count > 0 && userAddressDetails.count > indexPath.row {
            let userProfile = userAddressDetails[indexPath.row]
            DataManager.shared.setSelectedAddress(address: userProfile)
            self.delegate?.didReceiveSavedAddress(isUpdated: true, addressDetails: userProfile)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension DeliveryLocationViewController: ManageAddressDelegate {
    
    func didReceiveManageAddress(isUpdated: Bool?, address: String?, deliveryType: String?, addressId: Int?) {
        
        if isUpdated == true {
            getUserAddress()
        }
    }
}

extension DeliveryLocationViewController: PostViewProtocol {
    
   
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
    
       userAddressDetails = data ?? []
    }
    
    }
    
    
    if api == .userAddress, msg != nil {
    
        self.loader.isHidden = true
        self.getUserAddress()
    
    }
    
    tableView.reloadData()
    }
    

}
