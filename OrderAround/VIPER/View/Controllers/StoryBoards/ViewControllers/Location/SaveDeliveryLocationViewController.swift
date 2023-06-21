//
//  SaveDeliveryLocationViewController.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import GoogleMaps


struct TOCHECK_POSTORGET_METHOD {
    
    let POST = "POST"
    let GET = "GET"
}
enum MapSourceVC {
    case AddNew // Add new location from Profile
    case Save // Search and save location
    case Edit //Edit from Location from Profile
    case Current // Current location
}

class SaveDeliveryLocationViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var swapGestureView: UIView!
    @IBOutlet weak var sawpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var saveAddressLocation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var locationManager = CLLocationManager()
    let currentLocationMarker = GMSMarker()
    var floatingMarker = UIButton()
    var delegate: ManageAddressDelegate?
    var currentLocation = CLLocationCoordinate2D()
    var userAddressDetails: UserAddressDetails?
    var isFromEditAddress: Bool = false
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    var addressTypeString = String()
    var building: String?
    var street = String()
    var city = String()
    var state = String()
    var country = String()
    var pincode = String()
    var landmark: String?
    var map_address = String()
    var latitude = String()
    var longitude = String()
    var type = APPLocalize.localizestring.other.localize().lowercased()
    var userAddressInfo: UserAddressInfo?
    var buildingTxtFld = UITextField()
    var landMark = UITextField()
    var indexCount = [1,2,3]
    var isFromGetList = String()
    var editId = String()
    var fromVC:MapSourceVC!
    var mapViewHelper : GoogleMapsHelper?
    
    private lazy var buttonCurrentLocation : UIButton = {
       let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "locator-24"), for: .normal)
        self.mapView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -8).isActive = true
        button.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor, constant: -8).isActive = true
        return button
    }()
    
    private lazy var markerButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "floatingMarker"), for: .normal)
        self.mapView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.basicSetup()
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enableKeyboardHandling()
        
        if isFromEditAddress {
            
            editId = String(describing: (userAddressDetails?.id)!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mapViewHelper?.mapView?.frame = mapView.bounds

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
    //UI Design Setups
    
    func basicSetup() {
        
        mapSetup()
        designSetup()
        tableViewSetup()
       // registerNotifications()
       self.tableView.isUserInteractionEnabled = false
    }
    
    func mapSetup(){
        createFloatingMarker()
        inializeMapView()
        
    }
    
    func designSetup(){
        localize()
        setCustomFont()
        configureSwipeView()
        buttonCurrentLocation.addTarget(self, action: #selector(self.currentLocationEvent(_:)), for: .touchUpInside)
    }
    
    func tableViewSetup() {
        tableView.register(UINib(nibName: XIB.Names.SaveDeliveryLocationCell, bundle: nil), forCellReuseIdentifier: XIB.Names.SaveDeliveryLocationCell)
        tableView.register(UINib(nibName: XIB.Names.AddressAddingCell, bundle: nil), forCellReuseIdentifier: XIB.Names.AddressAddingCell)
        tableView.separatorStyle = .none
    }
   
    func localize() {
        
        skipButton.setTitle(APPLocalize.localizestring.skip.localize(), for: .normal)
        saveAddressLocation.text = APPLocalize.localizestring.setDeliveryLocation.localize()
    }
    
    func setCustomFont() {
        Common.setFont(to: saveAddressLocation, isTitle: true, size: 17, fontType: .semiBold)
        Common.setFont(to: skipButton, isTitle: true, size: 15, fontType: .semiBold)
    }
    
    func maximiseLocationDetaisView(){
        self.mapViewHelper?.mapView?.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
         self.view.layoutIfNeeded()
    }
    
    func minimiseLocationDetailsView() {
        self.mapViewHelper?.mapView?.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.2).isActive = true
        self.view.layoutIfNeeded()
    }
    
    
    //MAPView Setup
    
    func inializeMapView() {
        self.mapViewHelper = GoogleMapsHelper()
        self.mapViewHelper?.getMapView(withDelegate: self, in: self.mapView)
        
        guard let sourceVC = fromVC else { return }
        
        switch sourceVC {
        case .Save:
            self.mapViewHelper?.mapView?.isMyLocationEnabled = true
            focusSelectedLocation(location: currentLocation)
        case .Current:
            updateCurrentLocation()
        case .Edit:
            self.skipButton.isHidden = true
            setEditAddressDetails()
        case .AddNew:
             self.skipButton.isHidden = true
             updateCurrentLocation()
            break
       
        }
    }
    
    func setEditAddressDetails() {
        if let editAddress = userAddressDetails {
            setMarkerIcon(type: editAddress.type ?? "")
            self.type = editAddress.type ?? ""
            focusSelectedLocation(location: CLLocationCoordinate2D(latitude: editAddress.latitude ?? 0, longitude: editAddress.longitude ?? 0))
        }
    }
    
    func setMarkerIcon(type:String) {
        switch type {
        case  APPLocalize.localizestring.home.localize().lowercased():
            self.markerButton.setImage(#imageLiteral(resourceName: "HomeMarker"), for: .normal)
        case  APPLocalize.localizestring.work.localize().lowercased():
            self.markerButton.setImage(#imageLiteral(resourceName: "workMarker"), for: .normal)
        case  APPLocalize.localizestring.others.localize().lowercased():
            self.markerButton.setImage(#imageLiteral(resourceName: "floatingMarker"), for: .normal)
        default:
            self.markerButton.setImage(#imageLiteral(resourceName: "floatingMarker"), for: .normal)
        }
    }
    func updateCurrentLocation() {
    
        self.mapViewHelper?.mapView?.isMyLocationEnabled = true
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
            self.focusSelectedLocation(location: location.coordinate)
        })
    }
    
    func focusSelectedLocation(location:CLLocationCoordinate2D) {
        self.mapViewHelper?.moveTo(location: location, with: mapView.center)
        moveMapMarkerToCenter()
        updateCurrentLocationAddress(location: location)
    }
    
    func updateCurrentLocationAddress(location:CLLocationCoordinate2D) {
        self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetails) in
            self.map_address = locationDetails.address
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func addMarkerOnSelectedLocation() {
        
    }
    
    func moveMapMarkerToCenter() {
        markerButton.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.1).isActive = true
        markerButton.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.1).isActive = true
        markerButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        markerButton.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
        
    }
}


extension SaveDeliveryLocationViewController {
    
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
    // MARK: - Adding Swap Gesture to SwapView
    func configureSwipeView() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.swapGestureView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.swapGestureView.addGestureRecognizer(swipeDown)
        
    }

    // MARK: handleSwapGesture Action
    
    @objc private dynamic func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
            
        case UISwipeGestureRecognizerDirection.down:
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: { () -> Void in
                self.sawpViewHeightConstraint.constant = 0//self.view.frame.width * 0.4
                self.tableView.isUserInteractionEnabled = false
                self.view.layoutIfNeeded()
                self.mapViewHelper?.mapView?.frame = self.mapView.bounds
            }, completion: nil)
            
        case UISwipeGestureRecognizerDirection.up:
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: { () -> Void in
                self.sawpViewHeightConstraint.constant = self.view.frame.width * 0.73
                self.tableView.isUserInteractionEnabled = true
                self.view.layoutIfNeeded()
                self.mapViewHelper?.mapView?.frame = self.mapView.bounds
            }, completion: nil)
            
            
        default:
            break
        }
    }
    
}


extension SaveDeliveryLocationViewController {
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        
        self.delegate?.didReceiveManageAddress(isUpdated: false, address: Constants.string.empty, deliveryType: Constants.string.empty, addressId: 0)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func currentLocationEvent(_ sender: UIButton) {
        
        //inializeMapView()
        updateCurrentLocation()
        
    }
    
    @IBAction func skipClickEvent(_ sender: UIButton) {

        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 2 {
                self.navigationController?.popToViewController(viewControllers[0], animated: true)
            }
        }
    }
}


//MARK: UITableViewDelegate & UITableViewDataSource

extension SaveDeliveryLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return indexCount.count > 0 ? indexCount.count : 0
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
            return tableView.frame.size.width * 0.15//55
        case 1:
            return tableView.frame.size.width * 0.4//190
        default:
            return 0
        }
    }
    
    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return tableView.frame.size.width * 0.1//35
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            
        case 0:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35)
            headerView.backgroundColor = .white
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 10, y: 2, width: tableView.frame.width - (2 * 20), height: 30)
            headerLbl.text = APPLocalize.localizestring.address.localize()
            Common.setFont(to: headerLbl, size : 14, fontType : FontCustom.regular)
            headerLbl.textColor = UIColor.black
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddressAddingCell, for: indexPath) as! AddressAddingCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.textField.delegate = self
            cell.textField.tag = indexPath.row
            if indexPath.row == 1 {
                
                if isFromEditAddress {
                    cell.textField.text = userAddressDetails?.building
                }
                
                cell.textField.placeholder = APPLocalize.localizestring.houseNo.localize()
                cell.textField.isUserInteractionEnabled = true
            } else if indexPath.row == 2 {
                
                if isFromEditAddress {
                    cell.textField.text = userAddressDetails?.landmark
                }
                  cell.textField.placeholder = APPLocalize.localizestring.landMark.localize()
                  cell.textField.isUserInteractionEnabled = true
                
            } else {
                
                if isFromEditAddress {
                    
                    cell.textField.text = userAddressDetails?.map_address
                }
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = self.map_address
            }
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SaveDeliveryLocationCell, for: indexPath) as! SaveDeliveryLocationCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.homeBut.addTarget(self, action: #selector(addressType), for: .touchUpInside)
            cell.workBut.addTarget(self, action: #selector(addressType), for: .touchUpInside)
            cell.othersBut.addTarget(self, action: #selector(addressType), for: .touchUpInside)
            cell.saveAndProceedBut.addTarget(self, action:  #selector(saveAndProceed), for: .touchUpInside)
            cell.cancel.addTarget(self, action: #selector(cancelTheOthersView), for: .touchUpInside)
            cell.othersTxtFLd.delegate = self
            cell.othersTxtFLd.tag = 3
            
            if let loadType = fromVC,loadType == .Edit,let loctionDetails = userAddressDetails {
                
                switch loctionDetails.type {
                case APPLocalize.localizestring.home.localize().lowercased():
                   cell.homeBut.changeTint(color: #colorLiteral(red: 1, green: 0.376491189, blue: 0, alpha: 1))
                case  APPLocalize.localizestring.work.localize().lowercased():
                     cell.workBut.changeTint(color: #colorLiteral(red: 1, green: 0.376491189, blue: 0, alpha: 1))
                case APPLocalize.localizestring.others.localize().lowercased():
                     cell.othersBut.changeTint(color: #colorLiteral(red: 1, green: 0.376491189, blue: 0, alpha: 1))
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        cell.othersView.isHidden = false
                        cell.locationTypeView.isHidden = true
                     }
                    
                default:
                cell.othersBut.changeTint(color: #colorLiteral(red: 1, green: 0.376491189, blue: 0, alpha: 1))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        cell.othersView.isHidden = false
                        cell.locationTypeView.isHidden = true
                    }
                }
            }
            
           /* if isFromEditAddress {
                
                if userAddressDetails?.type == Constants.string.home.lowercased().localize() {
                    cell.homeSelectedImg.image = #imageLiteral(resourceName: "homeSelected")
                    cell.othersSelected.image = #imageLiteral(resourceName: "map-marker")
                    cell.workSelectedImg.image = #imageLiteral(resourceName: "workUnselected")
                    type = Constants.string.home.lowercased().localize()
                } else if userAddressDetails?.type == Constants.string.work.lowercased().localize() {
                    cell.homeSelectedImg.image = #imageLiteral(resourceName: "homeUnselected")
                    cell.othersSelected.image = #imageLiteral(resourceName: "map-marker")
                    cell.workSelectedImg.image = #imageLiteral(resourceName: "workSelected")
                    type = Constants.string.work.lowercased().localize()
                } else {
                    
                    cell.homeSelectedImg.image = #imageLiteral(resourceName: "homeUnselected")
                    cell.othersSelected.image = #imageLiteral(resourceName: "otherSelected")
                    cell.workSelectedImg.image = #imageLiteral(resourceName: "workUnselected")
                    type = Constants.string.other.lowercased().localize()
                }
            }*/
            cell.layoutIfNeeded()
            cell.setNeedsDisplay()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SaveDeliveryLocationCell, for: indexPath) as! SaveDeliveryLocationCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            return cell
        }
    }
    
}

//MARK: Button Actions.
extension SaveDeliveryLocationViewController {
    
    @objc func addressType(sender: UIButton) {
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? SaveDeliveryLocationCell {
            
            switch sender.tag {
            case 999:
                cell.homeBut.changeTint(color: #colorLiteral(red: 1, green: 0.376491189, blue: 0, alpha: 1))
                cell.workBut.changeTint(color: .black)
                cell.othersBut.changeTint(color: .black)
                self.markerButton.setImage(#imageLiteral(resourceName: "HomeMarker"), for: .normal)
                self.type = APPLocalize.localizestring.home.localize().lowercased()
            case 888:
                cell.workBut.changeTint(color: #colorLiteral(red: 1, green: 0.376491189, blue: 0, alpha: 1))
                cell.homeBut.changeTint(color: .black)
                cell.othersBut.changeTint(color: .black)
                self.markerButton.setImage(#imageLiteral(resourceName: "workMarker"), for: .normal)
                 self.type = APPLocalize.localizestring.work.localize().lowercased()
            default:
                cell.othersBut.changeTint(color: #colorLiteral(red: 1, green: 0.376491189, blue: 0, alpha: 1))
                cell.homeBut.changeTint(color: .black)
                cell.workBut.changeTint(color: .black)
                self.markerButton.setImage(#imageLiteral(resourceName: "floatingMarker"), for: .normal)
                 self.type = APPLocalize.localizestring.others.localize().lowercased()
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    cell.othersView.isHidden = false
                    cell.locationTypeView.isHidden = true
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }

            
       /* if sender.tag == 999 {
           cell.homeSelectedImg.image = #imageLiteral(resourceName: "homeSelected")
           cell.othersSelected.image = #imageLiteral(resourceName: "map-marker")
           cell.workSelectedImg.image = #imageLiteral(resourceName: "workUnselected")
           type = Constants.string.home.lowercased().localize()
        
        } else if sender.tag == 888 {
            cell.homeSelectedImg.image = #imageLiteral(resourceName: "homeUnselected")
            cell.othersSelected.image = #imageLiteral(resourceName: "map-marker")
            cell.workSelectedImg.image = #imageLiteral(resourceName: "workSelected")
            type = Constants.string.work.lowercased().localize()
        
        } else {
            cell.homeSelectedImg.image = #imageLiteral(resourceName: "homeUnselected")
            cell.othersSelected.image = #imageLiteral(resourceName: "otherSelected")
            cell.workSelectedImg.image = #imageLiteral(resourceName: "workUnselected")
            type = Constants.string.other.lowercased().localize()
        
            UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: ({
               // cell.othersView.frame = CGRect(x:  15 , y:  cell.othersView.frame.origin.y, width: cell.othersView.frame.width, height: cell.othersView.frame.height)
                cell.othersView.isHidden = false
                cell.locationTypeView.isHidden = true
                
             
            }), completion: nil)
            
            self.tableView.reloadData()
        } */
      }
    }
    
    @objc func saveAndProceed(sender: UIButton) {
        
        if fieldValidation() {
            postUserAddress()
        }
        
    }
    
    @objc func cancelTheOthersView(sender: UIButton) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? SaveDeliveryLocationCell {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                cell.locationTypeView.isHidden = false
                cell.othersView.isHidden = true
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
            
//            UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: ({
//                 // cell.othersView.frame = CGRect(x: cell.othersView.frame.width + cell.othersView.frame.origin.x + 15, y:  cell.othersView.frame.origin.y, width: cell.othersView.frame.width, height: cell.othersView.frame.height)
//                cell.othersView.isHidden = true
//                cell.locationTypeView.isHidden = false
//            }), completion: nil)
//
//
//           tableView.reloadData()
        }
    }
    
    func fieldValidation() -> Bool {
        
        var returnBool = false
        for index in 0..<indexCount.count {
            let indexPath = IndexPath(row: index, section: 0)
            let cell:AddressAddingCell=(self.tableView.cellForRow(at: indexPath) as? AddressAddingCell)!
            if let textField = cell.textField {
                if (textField.text?.isEmpty)! {
                    if textField.tag == 1 {
                        self.showToast(string: APPLocalize.localizestring.enter.localize() + " " + APPLocalize.localizestring.houseNo.localize().lowercased())
                        returnBool = false
                        break;
                        
                    } else if textField.tag == 2 {
                        self.showToast(string: APPLocalize.localizestring.enter.localize() + " " + APPLocalize.localizestring.landMark.localize().lowercased())
                        returnBool = false
                        break;
                    }
                }
                if textField.tag == 1 {
                    self.building = textField.text ?? ""
                }
                if textField.tag == 2 {
                    self.landmark = textField.text ?? ""
                }
            }
            
            returnBool = true
        }
        return returnBool
    }
}

// MARK: - TextField Delegate
extension SaveDeliveryLocationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 2 {
            
            self.landmark = textField.text!
            
        } else if textField.tag == 1 {
            
            self.building = textField.text!
            
        } else if textField.tag == 3 {
            
            self.type = textField.text!
        }
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension SaveDeliveryLocationViewController: CLLocationManagerDelegate {
    
    
    func createFloatingMarker() {
        
        
        let visibleRect = CGRect(x: mapView.frame.origin.x, y: mapView.frame.origin.y, width: mapView.frame.size.width, height: mapView.frame.size.height)
        
        let centerPoint = CGPoint(x: visibleRect.size.width/2, y: visibleRect.size.height/2-23)
        print("*********** centerPoint",centerPoint)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = #imageLiteral(resourceName: "floatingMarker")
       // imageView.center = centerPoint
        self.mapView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.mapView.centerYAnchor).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        // self.mapViewHelper?.moveTo(location: location?.coordinate ?? CLLocationCoordinate2D(), with: self.mapView.center)
        // self.moveMapMarkerToCenter()
        
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) in
            if (error != nil) {
                
            }
            
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                if placemark.name != nil {
                    self.building = placemark.name!
                }
                if placemark.thoroughfare != nil {
                    self.street = placemark.thoroughfare!
                }
                if placemark.subThoroughfare != nil {
                    
                    self.city = placemark.subThoroughfare!
                }
                
                if placemark.administrativeArea != nil {
                    
                    self.state = placemark.administrativeArea!
                }
                if placemark.subAdministrativeArea != nil {
                    
                    self.city = placemark.subAdministrativeArea!
                }
                if placemark.postalCode != nil {
                    
                    self.pincode = placemark.postalCode!
                }
                
                if placemark.country != nil {
                    self.country = placemark.country!
                }
                
                
                let dict: NSDictionary =   placemark.addressDictionary! as NSDictionary
                let formattedAddressLines: [String] =  dict.value(forKey: "FormattedAddressLines") as! [String]
                let currentAddress = formattedAddressLines.joined(separator: ", ")
                
                self.map_address = currentAddress
                
            } })
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()

    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}


extension SaveDeliveryLocationViewController: GMSMapViewDelegate {

   
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        print("LAT",position.target.latitude)
        print("longitude",position.target.longitude)
    
        currentLocation.latitude = position.target.latitude
        currentLocation.longitude = position.target.longitude

        self.latitude =  "\(currentLocation.latitude)"
        self.longitude = "\(currentLocation.longitude)"
        
        let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
         let geoCoder = CLGeocoder()
         geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                
            }
            
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                if placemark.name != nil {
                
                    self.building = placemark.name!
                
                }
                if placemark.thoroughfare != nil {
                  self.street = placemark.thoroughfare!
                }
                if placemark.subThoroughfare != nil {
                
                  self.city = placemark.subThoroughfare!
                }
    
                
                if placemark.administrativeArea != nil {
                
                    self.state = placemark.administrativeArea!
                }
                if placemark.subAdministrativeArea != nil {
                
                   self.city = placemark.subAdministrativeArea!
                }
                if placemark.postalCode != nil {
                
                    self.pincode = placemark.postalCode!
                }
                if placemark.country != nil {
                
                      self.country = placemark.country!
                }
                if let dict: NSDictionary =   placemark.addressDictionary! as NSDictionary {
                let formattedAddressLines: [String] =  dict.value(forKey: "FormattedAddressLines") as! [String]
                let currentAddress = formattedAddressLines.joined(separator: ", ")

                self.map_address = currentAddress

                } }})
        
        tableView.reloadData()
    }
}



extension SaveDeliveryLocationViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
         self.loader.isHidden = true
        if api == .userAddress {
            if code == 422  {
                DispatchQueue.main.async {
                    self.alertControllerPresentEvent()
                }
            } else {
                self.showToast(string: message)
            }
        }else {
            self.showToast(string: message)
        }
        
    }
    
    func postUserAddress(isUpdate:Bool? = nil) {

        self.userAddressInfo = UserAddressInfo()
        userAddressInfo?.building = self.building
        userAddressInfo?.street = self.street
        userAddressInfo?.city = self.city
        userAddressInfo?.state = self.state
        userAddressInfo?.country = self.country
        userAddressInfo?.pincode = self.pincode
        userAddressInfo?.landmark = self.landmark
        userAddressInfo?.map_address = self.map_address
        userAddressInfo?.latitude = self.latitude
        userAddressInfo?.longitude = self.longitude
        userAddressInfo?.type = self.type
        if let _ = isUpdate {
            userAddressInfo?.update = "YES"
        } else {
            userAddressInfo?.update = "NO"
        }
        self.loader.isHidden = false
        
        if isFromEditAddress  {
            self.presenter?.patch(api: .userAddress, url: Base.userAddress.rawValue + "/" + editId , data: self.userAddressInfo?.toData())
           
        } else {
          self.presenter?.post(api: .userAddress, data: self.userAddressInfo?.toData())
        }
        
        isFromGetList = TOCHECK_POSTORGET_METHOD().POST
    }
    
    
    func getAddress(api: Base, data: [UserAddressDetails]?, msg: Message?) {
        
        
        if isFromGetList == TOCHECK_POSTORGET_METHOD().POST {
            
             getUserAddress()
             isFromGetList = TOCHECK_POSTORGET_METHOD().GET
        } else {
            
            if api == .userAddress, data != nil {
                self.loader.isHidden = true
                DataManager.shared.setUserAddressDetails(addressArray: data ?? [UserAddressDetails]())
                if let address = data?.last {
                     DataManager.shared.setSelectedAddress(address: address)
                }
               
                self.delegate?.didReceiveManageAddress(isUpdated: true, address: data?.last?.map_address, deliveryType:  data?.last?.type, addressId: data?.last?.id)
                self.navigationController?.popViewController(animated: true)
            } else {
                 self.loader.isHidden = true
                DataManager.shared.setUserAddressDetails(addressArray: data ?? [UserAddressDetails]())
                if let address = data?.last {
                    DataManager.shared.setSelectedAddress(address: address)
                }
                self.delegate?.didReceiveManageAddress(isUpdated: true, address: Constants.string.empty, deliveryType:  Constants.string.empty, addressId: 0)
                 self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    func getUserAddress() {
        
        self.loader.isHidden = false
        self.presenter?.get(api: .userAddress, data: nil)
    }
}


extension SaveDeliveryLocationViewController {
    func alertControllerPresentEvent() {
        
        let alert = UIAlertController(title: "", message: APPLocalize.localizestring.editAddressConfirmation.localize(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: APPLocalize.localizestring.yes.localize(), style: .default, handler: { action in
            
           self.postUserAddress(isUpdate: true)
        }))
        
        alert.addAction(UIAlertAction(title: APPLocalize.localizestring.Cancel.localize(), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
