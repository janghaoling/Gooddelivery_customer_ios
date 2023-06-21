//
//  HomeViewController.swift
//  Project
//
//  Created by CSS on 15/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import GoogleMaps
import GooglePlaces

struct SHOPSTATUS {
    
    let closed = "CLOSED"
    let open = "OPEN"
}
class HomeViewController: UIViewController {

    //MARK: - Declarations.
    @IBOutlet weak var noResturantFoundLbl: UILabel!
    @IBOutlet weak var seeIfAnyOtherFilterLbl: UILabel!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var shimmerView: UIView!
    
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageDownArrow: UIImageView!
    @IBOutlet weak var imageFilter: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    private var  headerHeight: CGFloat = 55
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var userLocation: UserCurrentLocation?
    var shopList =  [Shops]()
    var bannerImg = [Banners]()
    var refreshControl = UIRefreshControl()
    var filterDetailsArray:[String:[FilterItems]]!
  
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingServiceCall()
        
        controllerBasicSetup()
        addRefreshControl()
       // Register to receive notification
      // forceLogout()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        if isAppliedFilter(){
            filterImageView.isHidden = false
        } else {
            filterImageView.isHidden = true
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CollectionTableCell) as? CollectionTableCell
        cell?.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    func settingServiceCall() {
       self.presenter?.get(api: .settings, data: nil)
    }
    
    func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        getUserProfileDetails()
    }
    
    private func taleViewSetup() {
        tableView.register(UINib(nibName: XIB.Names.CollectionTableCell, bundle: nil), forCellReuseIdentifier: XIB.Names.CollectionTableCell)
        tableView.register(UINib(nibName: XIB.Names.OrderListCell, bundle: nil), forCellReuseIdentifier: XIB.Names.OrderListCell)
        tableView.separatorStyle = .none
    }
    
    private func controllerBasicSetup(){
        locatingCurrentLocation()
        localize()
        setCustomFont()
        taleViewSetup()
        addObservers()
        self.imageDownArrow.imageTintColor(color1: .secondary)
        self.imageFilter.imageTintColor(color1: .secondary)
        
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
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
    
    
    @IBAction func FilterRestaurantAction(_ sender: UIButton) {
        guard let filterData = filterDetailsArray else { return }
        let filter = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.FilterViewController) as! FilterViewController
        //        if filterApplied() {
        //             filter.filterDataSource = getFilterDetails()
        //        } else {
        //
        //        }
        
        filter.filterDataSource = filterData
        self.present(filter, animated: true, completion: nil)
    }
    
}

//MARK: - Button Actions.
extension HomeViewController {
    
    @IBAction func gettingCurrentAddress(_ sender: UIButton) {
        if User.main.id != nil {
            let locationVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DeliveryLocationViewController) as! DeliveryLocationViewController
            locationVC.delegate =  self
            self.navigationController?.pushViewController(locationVC, animated: true)
        } else {
            let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
            self.navigationController?.pushViewController(signIn, animated: true)
        }
        
    }
    
    func filterApplied() -> Bool {
        if getFilterDetails().count > 0 {
            let filters = getFilterDetails().map({$0.value.filter({$0.state == true})}).flatMap({$0})
            if filters.count > 0 {
                return true
            } else {
                return false
            }
            
        }else {
            return false
        }
    }
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
}

//MARK: - StringLocalize & Font design
extension HomeViewController {
    
    func localize() {
        filterLbl.text = APPLocalize.localizestring.filters.localize()
        locationLbl.text = APPLocalize.localizestring.locating.localize()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Wifi")
        case .cellular:
            print("Cellular")
        case .none:
            print("none")
        }
    }
    func setCustomFont() {
        
        Common.setFont(to: filterLbl, isTitle: true, size: 12, fontType: .semiBold)
        Common.setFont(to: locationLbl, isTitle: true, size: 15, fontType: .bold)
        Common.setFont(to: addressLbl, isTitle: true, size: 14, fontType: .light)
        Common.setFont(to: noResturantFoundLbl, isTitle: true, size: 16, fontType: .semiBold)
        Common.setFont(to: seeIfAnyOtherFilterLbl, isTitle: true, size: 14, fontType: .semiBold)
        
    }
}

//MARK: TableViewDelegate & TableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return shopList.count > 0 ? shopList.count : 0
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
            headerView.backgroundColor = .white
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 15, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
            headerLbl.text = APPLocalize.localizestring.letsImpress.localize()
            print("Ok".localized)
            Common.setFont(to: headerLbl, size : 14, fontType : FontCustom.semiBold)
            headerLbl.textAlignment = .left
            headerView.addSubview(headerLbl)
         
            return headerView
            
        case 1:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
            headerView.backgroundColor = .white
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 15, y: 15, width: tableView.frame.width - (2 * 20), height: 30)
            headerLbl.text = "\(shopList.count)"  + " " + APPLocalize.localizestring.totalResturant.localize()
            Common.setFont(to: headerLbl, size : 12, fontType : FontCustom.semiBold)
            headerLbl.textAlignment = .left
            headerView.addSubview(headerLbl)
            
            return headerView
       
        default:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: headerHeight)
          
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if bannerImg.count > 0 {
            return headerHeight
            } else {
               return 0
            }
        case 1:
            return headerHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
             if bannerImg.count > 0 {
                return 170
             } else {
                return 0
            }
        case 1:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.CollectionTableCell, for: indexPath) as! CollectionTableCell
            let nibPost = UINib(nibName: XIB.Names.TrendingCell, bundle: nil)
            cell.collectionView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.TrendingCell)
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            if !isAppliedFilter(){
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                cell.collectionView.collectionViewLayout = layout
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
                cell.collectionView.alwaysBounceHorizontal = false
                cell.collectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom:10, right: 5)
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.OrderListCell, for: indexPath) as! OrderListCell
            if shopList.count > indexPath.row {
                let shopListEntity = shopList[indexPath.row]
                cell.set(values: shopListEntity)
               // cell.rotateAnimation(imageView: cell.imageoffers)
                cell.imageoffers.rotate360Degrees()

            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.OrderListCell, for: indexPath) as! OrderListCell
           
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shopList.count > indexPath.row {
            
            let shopListEntity = shopList[indexPath.row]
            if shopListEntity.shopstatus == SHOPSTATUS().open {
                let redirectTest = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ResturantMenuListViewController) as! ResturantMenuListViewController
                redirectTest.shop = shopListEntity.id
                redirectTest.shopList = shopListEntity
                
                self.navigationController?.pushViewController(redirectTest, animated: true)
            } else {
                
                self.showToast(string: APPLocalize.localizestring.shopClosed.localize())
            }
        }
    }
}


//MARK: - Collectiopn View delegate & Datasource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bannerImg.count > 0 ? bannerImg.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.TrendingCell, for: indexPath) as! TrendingCell
         if bannerImg.count > 0 && bannerImg.count > indexPath.row {
            
          let bannerEntity = bannerImg[indexPath.row]
          cell.trendingProduct.setImage(with: bannerEntity.url, placeHolder: #imageLiteral(resourceName: "product_placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width/2)
        return CGSize(width: CGFloat(cellWidth), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 5, 10, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shopListEntity = bannerImg[indexPath.row]
        if shopListEntity.shopstatus == SHOPSTATUS().open {
            let redirectTest = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ResturantMenuListViewController) as! ResturantMenuListViewController
            redirectTest.shop = shopListEntity.shop?.id
            redirectTest.shopList = shopListEntity.shop
            
            self.navigationController?.pushViewController(redirectTest, animated: true)
        } else {
            
            self.showToast(string: APPLocalize.localizestring.shopClosed.localize())
        }
    }

}

//MARK: - Location Manager & PostViewProtocol

extension HomeViewController: PostViewProtocol {
    
    func getSettingsData(api: Base, data: SettingsEntity?) {
        //  Common.storeUserData(from: data)
        print("Check >>",data?.ios_api_key ?? "")
        
        GMSServices.provideAPIKey(data?.ios_api_key ?? "")
        GMSPlacesClient.provideAPIKey(data?.ios_api_key ?? "")
        
        googleMapKey = data?.ios_api_key ?? ""
        getUserProfileDetails()
        getCousineList()

    }
   
    func getUserProfileDetails() {
        if let items =  self.tabBarController?.tabBar.items {
            
            for i in 0 ..< items.count {
                let itemToDisable = items[i]
                itemToDisable.isEnabled = false
            }
        }
        if User.main.accessToken != nil {
            self.presenter?.get(api: .userProfile, data: nil)
        } else {
            self.userLocation = UserCurrentLocation()
            self.userLocation?.latitude = currentLocation.latitude
            self.userLocation?.longitude = currentLocation.longitude
            if getFilterDetails().count > 0 {
                var filterParam = [String:AnyObject]()
                filterParam["latitude"] = currentLocation.latitude as AnyObject
                filterParam["longitude"] = currentLocation.longitude as AnyObject
                let allFiltered = getFilterDetails().map({$0.value.filter({$0.state == true})}).flatMap({$0})
                let cuisinefiltered = allFiltered.filter({$0.type == APPLocalize.localizestring.Cuisines.localize()})
                let restaturntFilter = allFiltered.filter({$0.type == APPLocalize.localizestring.ShowRestaurantsWith.localize()})
                if cuisinefiltered.count > 0 {
                    //self.userLocation?.cuisine = cuisinefiltered.map({$0.id})
                    for (index,cuisineID) in cuisinefiltered.enumerated() {
                        //filterParam.append("cuisine[\(index)] = \(cuisineID)")
                        filterParam["cuisine[\(index)]"] = cuisineID.id as AnyObject
                    }
                    
                }
                if restaturntFilter.count > 0 {
                    let pureVeg = allFiltered.filter({$0.name == APPLocalize.localizestring.PureVeg.localize()})
                    let offer = allFiltered.filter({$0.name == APPLocalize.localizestring.Offer.localize()})
                    if pureVeg.count == 1 {
                        //self.userLocation?.pure_veg = 1
                        filterParam["pure_veg"] = 1 as AnyObject
                    }
                    if offer.count == 1 {
                        //self.userLocation?.offer = 1
                        filterParam["offer"] = 1 as AnyObject
                    }
                }
                if let theJSONData = try?  JSONSerialization.data(withJSONObject: filterParam,options: .prettyPrinted){
                    self.presenter?.get(api: .shopList, data: theJSONData)
                }
                
            } else {
                self.presenter?.get(api: .shopList, data: self.userLocation?.toData())
            }
            
        }
       
    }
    
    func getCousineList(){
        self.presenter?.get(api: .cuisines, data: nil)
    }
    
    func onError(api: Base, message: String, statusCode code: Int) {
        refreshControl.endRefreshing()
        shimmerView.isHidden = true
        self.showToast(string: message)
//        if(UIApplication.shared.isIgnoringInteractionEvents){
//
//            UIApplication.shared.endIgnoringInteractionEvents()
//
//        }
        
    }
    
    func getUserProfile(api: Base, data: UserProfileDetails?) {
         refreshControl.endRefreshing()
        if let items =  self.tabBarController?.tabBar.items {
            
            for i in 0 ..< items.count {
                let itemToDisable = items[i]
                itemToDisable.isEnabled = true
            }
        }
        if api == .userProfile, data != nil {
//            if(UIApplication.shared.isIgnoringInteractionEvents){
//
//                UIApplication.shared.endIgnoringInteractionEvents()
//
//            }
            Common.storeUserData(from: data)
            var cartCount = [Int]()
            if data?.cart?.count ?? 0 > 0 {
                
                for item in (data?.cart)! {
                    cartCount.append(Int(item.quantity ?? 0.0))
                }
            }
            
            if let address = data?.addresses {
                DataManager.shared.setUserAddressDetails(addressArray: address)
            }
            
            let totalcartCount = cartCount.reduce(0, +)
           
            if totalcartCount > 0 {
                User.main.cartCount = totalcartCount
            }
            
            self.userLocation = UserCurrentLocation()
            self.userLocation?.latitude = currentLocation.latitude
            self.userLocation?.longitude = currentLocation.longitude
            self.userLocation?.user_id = User.main.id
            if getFilterDetails().count > 0 {
                var filterParam = [String:AnyObject]()
                filterParam["latitude"] = currentLocation.latitude as AnyObject
                filterParam["longitude"] = currentLocation.longitude as AnyObject
                let allFiltered = getFilterDetails().map({$0.value.filter({$0.state == true})}).flatMap({$0})
                let cuisinefiltered = allFiltered.filter({$0.type == APPLocalize.localizestring.Cuisines.localize()})
                let restaturntFilter = allFiltered.filter({$0.type == APPLocalize.localizestring.ShowRestaurantsWith.localize()})
                if cuisinefiltered.count > 0 {
                    for (index,cuisineID) in cuisinefiltered.enumerated() {
                        filterParam["cuisine[\(index)]"] = cuisineID.id as AnyObject
                    }
                }
                
                if restaturntFilter.count > 0 {
                    let pureVeg = allFiltered.filter({$0.name == APPLocalize.localizestring.PureVeg.localize()})
                    let offer = allFiltered.filter({$0.name == APPLocalize.localizestring.Offer.localize()})
                    if pureVeg.count == 1 {
                        filterParam["pure_veg"] = 1 as AnyObject
                    }
                    if offer.count == 1 {
                        filterParam["offer"] = 1 as AnyObject
                    }
                }
                
                if let theJSONData = try?  JSONSerialization.data(withJSONObject: filterParam,options: .prettyPrinted){
                    self.presenter?.get(api: .shopList, data: theJSONData)
                }
                
            } else {
                self.presenter?.get(api: .shopList, data: self.userLocation?.toData())
            }
        }
    }
    
    func shopList(api: Base, data: Json4Swift_Base?) {
         refreshControl.endRefreshing()
        if api == .shopList, data != nil {
          
            bannerImg = (data?.banners)!
            shopList = (data?.shops)!
            if isAppliedFilter(){
                bannerImg = [Banners]()
            }
            
            if  User.main.cart != nil {
                if let tabItems = tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[2]
                    if User.main.cartCount == 0 || User.main.cartCount == nil {
                        tabItem.badgeValue = nil
                    }else{
                        tabItem.badgeValue = "\(User.main.cartCount ?? 0)"
                    }
                }
            }
            
            
            if shopList.count > 0 {
                shimmerView.isHidden = true
                self.tableView.backgroundView = nil
            } else {
                shimmerView.isHidden = true
                self.tableView.setBackgroundImageAndTitle(imageName: EmptyImage.restaurantEmpty.rawValue, title: APPLocalize.localizestring.noRestaurant.localize(), description: APPLocalize.localizestring.noRestaurantContent.localize())
            }
            self.tableView.reloadData()
        }
    }
    
    func getCuisinesList(api: Base, data: [Cuisines]?) { //, msg: Message?
        if api == .cuisines, data != nil {
           constructFilterDataSource(data: data ?? [Cuisines]())
        }
    }
    
    func constructFilterDataSource(data:[Cuisines]) {
        var restaurantsWithArray = [FilterItems(name: APPLocalize.localizestring.Offer.localize(), state: false, id: 0, type: APPLocalize.localizestring.ShowRestaurantsWith.localize()),FilterItems(name: APPLocalize.localizestring.PureVeg.localize(), state: false, id: 0, type: APPLocalize.localizestring.ShowRestaurantsWith.localize())]
        
        var tempArray = [FilterItems]()
        for cusine in data {
            let filterObject =  FilterItems(name: cusine.name ?? "", state: false, id: cusine.id ?? 0, type: APPLocalize.localizestring.Cuisines.localize())
            tempArray.append(filterObject)
        }
        
        restaurantsWithArray += tempArray
        let applied = getFilterDetails().map({$0.value.filter({$0.state == true})}).flatMap({$0})
        
        for appliedObject in applied {
            for (index,defaultObject) in restaurantsWithArray.enumerated() {
                if defaultObject.id == appliedObject.id && defaultObject.name == appliedObject.name {
                    restaurantsWithArray.remove(at: index)
                    restaurantsWithArray.insert(appliedObject, at: index)
                }
            }
        }
     
        filterDetailsArray = Dictionary(grouping: restaurantsWithArray, by: {$0.type})
    }
}

//MARK: - Location Manager & CLLocationManagerDelegat
extension HomeViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentLocation.latitude = (location?.coordinate.latitude)!
        currentLocation.longitude = (location?.coordinate.longitude)!
        
        let locations = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations, completionHandler: {(placemarks, error) in
            if (error != nil) {
                
            }
            
             var userAddress = String()
            
            if (Reachability()?.connection != .none) {
            let placemark = placemarks! as [CLPlacemark]
                
            if placemark.count > 0 {
                let placemark = placemarks![0]
            
                    if placemark.name != nil {
                        
                        userAddress =  userAddress + placemark.name! + ", "
                    }
                    if placemark.thoroughfare != nil {
                        userAddress = userAddress + placemark.thoroughfare! + ", "
                    }
                    if placemark.subThoroughfare != nil {
                        
                        userAddress =  userAddress + placemark.subThoroughfare! + ", "
                    }
                    if placemark.locality != nil {
                        userAddress =  userAddress + placemark.locality! + ", "
                    }
                    if placemark.subLocality != nil {
                        self.locationLbl.text = placemark.subLocality
                        userAddress =  userAddress + placemark.subLocality! + ", "
                        
                    }
                    if placemark.administrativeArea != nil {
                        
                        userAddress =  userAddress + placemark.administrativeArea! + ", "
                    }
                    if placemark.subAdministrativeArea != nil {
                        
                        userAddress =  userAddress + placemark.subAdministrativeArea! + ","
                    }
                    if placemark.postalCode != nil {
                        
                        userAddress =  userAddress + placemark.postalCode! + ","
                    }
                    if placemark.isoCountryCode != nil {
                        
                        userAddress =  userAddress + placemark.isoCountryCode! + ","
                    }
                    
                    if placemark.country != nil {
                        
                        userAddress =  userAddress + placemark.country!
                    }
                    
                    print("userAddress:",userAddress)
                    self.addressLbl.text = userAddress.localize()
                }
        
                
            } })
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}



extension HomeViewController: SavedAddressDelegate {
    
    func didReceiveSavedAddress(isUpdated: Bool?, addressDetails: UserAddressDetails?) {
        
        if isUpdated == true {
            
            locationLbl.text = addressDetails?.type?.uppercased()
            addressLbl.text = addressDetails?.map_address
            currentLocation.latitude = (addressDetails?.latitude)!
            currentLocation.longitude = (addressDetails?.longitude)!
            
            self.userLocation = UserCurrentLocation()
            self.userLocation?.latitude = currentLocation.latitude
            self.userLocation?.longitude = currentLocation.longitude
            self.userLocation?.user_id = User.main.id
            self.shimmerView.isHidden = false
            self.presenter?.get(api: .shopList, data: self.userLocation?.toData())
        
        }
    }

}

        

    
    

