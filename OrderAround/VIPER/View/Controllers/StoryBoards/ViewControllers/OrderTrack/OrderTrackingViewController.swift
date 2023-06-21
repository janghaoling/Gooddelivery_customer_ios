//
//  OrderTrackingViewController.swift
//  Project
//
//  Created by CSS on 24/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import GoogleMaps

class OrderTrackingViewController: UIViewController {
    
    enum orderIcons : String, Codable {
        case orderPlace = "ic_order_placed"
        case orderConfirm = "ic_confirm"
        case orderProcess = "ic_chef"
        case orderPicked = "ic_order_picked"
        case orderDelivered = "ic_delivery"
        case orderLine = "ic_line"
        
        static let orderImages = [orderPlace, orderConfirm, orderProcess,orderPicked,orderDelivered,orderLine]
    }
    
    enum pastOrderIcon : String,CaseIterable {
        case location = "ic_location_unselect"
        case home =  "ic_home_unselect"
        case cancelLine = "ic_line_cancel"
        
        static let pastIcons = [location, home, cancelLine]
    }
    
    @IBOutlet weak var labelItems: UILabel!
    @IBOutlet weak var labelOTP: UILabel!
    @IBOutlet weak var labelOrderNumber: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var buttonCancel:UIButton!
    
    private var cancelView : CancelView?
    
    var isFromMyOrder = false
    
    var headerHeight: CGFloat = 55
    var orderStatusTitle = [APPLocalize.localizestring.orderPlaced.localize(),APPLocalize.localizestring.orderConfirmed.localize(),APPLocalize.localizestring.orderProcessed.localize(),APPLocalize.localizestring.orderPickedUp.localize(),APPLocalize.localizestring.orderDelivered.localize()]
    
     var orderStatusDescription = [APPLocalize.localizestring.orderPlacedDescription.localize(),APPLocalize.localizestring.orderConfirmedDescription.localize(),APPLocalize.localizestring.orderProcessedDescription.localize(),APPLocalize.localizestring.orderPickedUpDescription.localize(),APPLocalize.localizestring.orderDeliveryDescription.localize()]
    
    var orderDetails : OrderList?
    var disputeArr : [Dispute]?
    var isPastOrder:Bool = false
    
    
    let mapView = GMSMapView()
    let detailButton = UIButton()
    let helpButton = UIButton()
    let divideLine = UIView()
    let helpDividerLine = UIView()
    var footerSelectionView = UIView()
    let scrollView = UIScrollView()
    let detailsTableView = UITableView()
    let helpTableView = UITableView()
    var driverLastLocation = LocationCoordinate()
    var isCancelClicked:Bool = false
    
    var shopMarker : GMSMarker = {
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.icon =  UIImage(named:"restaurantmarker")?.resizeImage(newWidth: 30)
        return marker
    }()
    var homeMarker : GMSMarker = {
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.icon =  UIImage(named: "HomeMarker")? .resizeImage(newWidth: 30)
        return marker
    }()
    var driverMarker : GMSMarker = {
        let marker = GMSMarker()
        marker.icon =  UIImage(named: "bike")? .resizeImage(newWidth: 30)
        return marker
    }()
    
    
    var orderTimer : Timer?
    
    var isFirstSelect = false {
        didSet {
            UIView.animate(withDuration: 0.7, animations: {
                self.divideLine.frame = CGRect(x: self.isFirstSelect ? 0 : self.detailButton.frame.size.width, y: self.detailButton.frame.maxY, width: 100, height: 2)
            })
        }
    }
    
    var isHelpTableShow = false {
        didSet {
            if isHelpTableShow {
                let itemCount = orderDetails?.items?.count ?? 0
                UIView.animate(withDuration: 0.7, animations: {
                    self.helpTableView.frame = CGRect(x: 0 , y:  self.footerSelectionView.frame.maxY, width: self.view.frame.width, height: CGFloat(itemCount * 50 * 10))
                     self.detailsTableView.frame = CGRect(x: -self.view.frame.width , y:  self.footerSelectionView.frame.maxY, width: self.view.frame.width, height: CGFloat(itemCount * 50 * 10))
                })
            }else{
                let itemCount = orderDetails?.items?.count ?? 0
                UIView.animate(withDuration: 0.7, animations: {
                    self.helpTableView.tableFooterView = UIView()
                    self.detailsTableView.frame = CGRect(x: 0 , y:  self.footerSelectionView.frame.maxY, width: self.view.frame.width, height: CGFloat(itemCount * 50 * 10))
                     self.helpTableView.frame = CGRect(x: +self.view.frame.width , y:  self.footerSelectionView.frame.maxY, width: self.view.frame.width, height: CGFloat(itemCount * 50 * 10))
                })
            }
        }
    }
    
    var isCancelled:Bool = false
    var isCancelOrder:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (_) in
            self.getOrderAPI()
        }
        self.isCancelled = orderDetails?.status == OrderStatus.CANCEL.rawValue
        if isCancelled || isPastOrder {
            self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
        }
        self.labelOTP.text = APPLocalize.localizestring.OTP.localize() + "  : "  +  "\(orderDetails?.order_otp ?? 0)"
        self.labelItems.text = "\(orderDetails?.items?.count ?? 0)" + APPLocalize.localizestring.item.localize()  + "," + "\(Common.showAmount(amount: orderDetails?.invoice?.payable ?? 0))"
        self.labelOrderNumber.text = "\(APPLocalize.localizestring.order.localize()) #000\(orderDetails?.id ?? 0)"
        self.presenter?.get(api: .disputeHelp, data: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        orderTimer?.invalidate()
        orderTimer = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstSelect = true
        isHelpTableShow = false
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        if self.cancelView == nil, let cancelView = Bundle.main.loadNibNamed(XIB.Names.CancelView, owner: self, options: [:])?.first as? CancelView {
            cancelView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.cancelView = cancelView
            self.cancelView?.setValues(isDispute: false, orderID: self.labelOrderNumber.text ?? "", title: "")
            self.view.addSubview(cancelView)
            self.cancelView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.5),
                           initialSpringVelocity: CGFloat(1.0),
                           options: .allowUserInteraction,
                           animations: {
                            self.cancelView?.transform = .identity },
                           completion: { Void in()  })
            
        }
        self.cancelView?.onClickClose = {
            self.cancelView?.removeFromSuperview()
            self.cancelView = nil
        }
        self.cancelView?.onClickSubmit = { (reason,title) in
            var cancelOrder = CancelOrder()
            cancelOrder.reason = reason
            self.isCancelOrder = true
            self.presenter?.delete(api: .order, url: "\(Base.order.rawValue)/\(self.orderDetails?.id ?? 0)", data: cancelOrder.toData())
        }
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        if isFromMyOrder {
            self.navigationController?.popViewController(animated: true)

            
        }else{
            let baseHomeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController)
            self.navigationController?.pushViewController(baseHomeVC, animated: true)
        }
    }
    
    deinit {
        orderTimer?.invalidate()
        orderTimer = nil
    }
}

//MARK: - Methods

extension OrderTrackingViewController {
    private func initialLoads() {
        setCustomFont()
        helpDividerLine.backgroundColor = .white
        divideLine.backgroundColor = .secondary
        tableView.register(UINib(nibName: XIB.Names.OrderTrackCell, bundle: nil), forCellReuseIdentifier: XIB.Names.OrderTrackCell)
        tableView.separatorStyle = .none
        self.buttonCancel.addTarget(self, action: #selector(tapCancel(_:)), for: .touchUpInside)
        self.localize()
        self.getOrderAPI()
        self.setMap()
    }
    
    func getOrderAPI()  {
        self.presenter?.get(api: .order, url: "\(Base.order.rawValue)/\(self.orderDetails?.id ?? 0)")
    }
    
    func localize() {
        buttonCancel.setTitle(APPLocalize.localizestring.Cancel.localize(), for: .normal)
        labelItems.textColor = .lightGray
        buttonCancel.setTitleColor(.secondary, for: .normal)
        
    }
    
    func setCustomFont() {
        
        Common.setFont(to: labelItems, isTitle: true, size: 13, fontType: .light)
        Common.setFont(to: labelOrderNumber, isTitle: true, size: 16, fontType: .bold)
        Common.setFont(to: labelOTP, isTitle: false, size: 13, fontType: .regular)
    }
    
    func setMap() {
        let shopPosition = CLLocationCoordinate2D(latitude: orderDetails?.shop?.latitude ?? defaultMapLocation.latitude, longitude: orderDetails?.shop?.longitude ?? defaultMapLocation.longitude)
        let homePosition = CLLocationCoordinate2D(latitude: orderDetails?.address?.latitude ?? defaultMapLocation.latitude, longitude: orderDetails?.address?.longitude ?? defaultMapLocation.longitude)
        mapView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: orderDetails?.shop?.latitude ?? defaultMapLocation.latitude, longitude: orderDetails?.shop?.longitude ?? defaultMapLocation.longitude), zoom: 15)
        shopMarker.position = shopPosition
        shopMarker.snippet = orderDetails?.shop?.address
        shopMarker.map = self.mapView
        
        homeMarker.position = homePosition
        homeMarker.snippet = orderDetails?.address?.map_address
        homeMarker.map = self.mapView
        
        self.mapView.animate(toLocation: shopPosition)
        drawPolyline()
    }
}

extension OrderTrackingViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            if isCancelled || isPastOrder {
                return 2
            }
            return  orderStatusTitle.count > 0 ?  orderStatusTitle.count : 0
            
        } else if tableView == self.detailsTableView {
            return orderDetails?.items?.count ?? 0 > 0 ?  orderDetails?.items?.count ?? 0 : 0
        }else if tableView == self.helpTableView {
            return self.disputeArr?.count ?? 0
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
        
            return 70
        } else if tableView == self.detailsTableView {
            return UITableViewAutomaticDimension
        }else if tableView == self.helpTableView {
            return UITableViewAutomaticDimension
        } else {
            
            return 0
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView {
            return  isCancelled || isPastOrder ? 0 : 180
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 180))
        headerView.backgroundColor = .white
        mapView.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        mapView.delegate = self
        headerView.addSubview(mapView)
        
        return isCancelled || isPastOrder ? UIView(frame: CGRect.zero) : headerView
         
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.tableView {
            let orderItem = orderDetails?.items?.count
            let number = 50 * orderItem!          //50
            return CGFloat(number + 300) //.
        } else if tableView == self.detailsTableView {
            
            return 180
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if tableView == self.tableView {
            
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 585))
            footerView.backgroundColor = .white
       
            let orderNumberView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 35))
            let image = UIImageView(frame: CGRect(x: 15, y: (orderNumberView.frame.height/2)-10, width: 20, height: 20))
            self.setPastOrderImage(image: image)
            let label = UILabel(frame: CGRect(x: isPastOrder || isCancelled ? image.frame.maxX+5 : 15 , y: (orderNumberView.frame.height/2)-7, width: orderNumberView.frame.width - image.frame.maxX, height: 15))
            self.setOrderHeader(label: label)
            
            orderNumberView.addSubview(image)
            orderNumberView.addSubview(label)
            footerView.addSubview(orderNumberView)

            footerSelectionView = UIView(frame: CGRect(x: 10, y: orderNumberView.frame.maxY, width: footerView.frame.width - (2*15), height: 50))
            footerView.addSubview(footerSelectionView)
        
            let detailsView = UIView(frame: CGRect(x: 0, y: 5, width: 100, height: 40))
            footerSelectionView.addSubview(detailsView)
        
            detailButton.frame = CGRect(x: 0, y: 0, width: detailsView.frame.width, height: 35)
            Common.setFont(to: detailButton, isTitle: true, size: 14, fontType: .semiBold)
            detailButton.setTitle(APPLocalize.localizestring.details.localize(), for: .normal)
            detailButton.setTitleColor(UIColor.black, for: .normal)
            detailButton.addTarget(self, action: #selector(detailsClickEvent), for: .touchUpInside)
            detailsView.addSubview(detailButton)
        
            divideLine.backgroundColor = .secondary
            detailsView.addSubview(divideLine)
        
            let helpView = UIView(frame: CGRect(x: detailsView.frame.maxX + 15, y: 5, width: 80, height: 40))
            footerSelectionView.addSubview(helpView)
        
        
            helpButton.frame = CGRect(x: 0, y: 0, width: helpView.frame.width, height: 35)
            Common.setFont(to: helpButton, isTitle: true, size: 14, fontType: .semiBold)
            helpButton.setTitle(APPLocalize.localizestring.help.localize(), for: .normal)
            helpButton.addTarget(self, action: #selector(helpClickEvent), for: .touchUpInside)
            helpButton.setTitleColor(UIColor.black, for: .normal)
            helpView.addSubview(helpButton)
            
            detailsTableView.dataSource = self
            detailsTableView.delegate = self
            footerView.addSubview(detailsTableView)
            
            helpTableView.dataSource = self
            helpTableView.delegate = self
            footerView.addSubview(helpTableView)
        
            helpTableView.register(UITableViewCell.self, forCellReuseIdentifier: XIB.Names.HelpCell)
            detailsTableView.register(UINib(nibName: XIB.Names.OrderDetailsCell, bundle: nil), forCellReuseIdentifier: XIB.Names.OrderDetailsCell)
            detailsTableView.register(UINib(nibName: XIB.Names.OrderPaymentCell, bundle: nil), forCellReuseIdentifier: XIB.Names.OrderPaymentCell)
            
            detailsTableView.separatorStyle = .none
         return footerView
            
         }else if tableView == detailsTableView {
            
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: XIB.Names.OrderPaymentCell) as! OrderPaymentCell
            guard let invoice = orderDetails?.invoice else{
                return UITableViewCell()
            }
            cell.setPaymentValues(invoice: invoice)
            return cell
            
         } else {
            
            return UIView()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.OrderTrackCell, for: indexPath) as! OrderTrackCell
            if isCancelled || isPastOrder {
                cell.imageIcon.image = UIImage(named: pastOrderIcon.pastIcons[indexPath.row].rawValue)
                cell.imageLine.image = UIImage(named: orderDetails?.status == OrderStatus.CANCEL.rawValue ? pastOrderIcon.cancelLine.rawValue : orderIcons.orderLine.rawValue)
                cell.imageLine.isHidden = indexPath.row == 1
                let titleArr = [orderDetails?.shop?.name,orderDetails?.address?.type?.uppercased()]
                let addressInstance = orderDetails?.address
                let homeAddress = "\(addressInstance?.street ?? ""), \(addressInstance?.city  ?? ""), \(addressInstance?.country ?? "")"
                let addressArr = [orderDetails?.shop?.address,homeAddress]
                cell.labelTitle.text = titleArr[indexPath.row]
                cell.labelDescription.text = addressArr[indexPath.row]
                self.buttonCancel.isHidden = true
                self.labelOTP.isHidden = true
            }else{
                cell.imageIcon.image = UIImage(named: orderIcons.orderImages[indexPath.row].rawValue)
                cell.labelTitle.text = orderStatusTitle[indexPath.row]
                cell.labelDescription.text = orderStatusDescription[indexPath.row]
                cell.imageLine.isHidden = orderStatusTitle[indexPath.row] == APPLocalize.localizestring.orderDelivered.localize()
                let index = OrderStatus.allCases.indexesOf(object: OrderStatus(rawValue: orderDetails?.status ?? "") ?? OrderStatus.None)
                self.buttonCancel.isHidden = index != 0
                self.labelOTP.isHidden = orderDetails?.order_otp == 0 || (orderDetails?.order_otp == nil)
                let row = indexPath.row
                switch row {
                case 0:
                    cell.isFontBold = index == row ? true : false
                case 1:
                    cell.isFontBold = index == row ? true : false
                case 2:
                    if index == 2 || index == 3 || index == 4 {
                        self.moveProviderMarker()
                        cell.isFontBold = true
                    }else{
                        self.driverMarker.map  = nil
                        cell.isFontBold = false
                    }
                case 3:
                    if index == 5 || index == 6 {
                        self.moveProviderMarker()
                        cell.isFontBold = true
                    }else{
                        self.driverMarker.map  = nil
                        cell.isFontBold = false
                    }
                case 4:
                    if index == 7{
                        cell.isFontBold = true
                        let vc:FeedBackController = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.FeedBackController) as! FeedBackController
                            vc.orderId = orderDetails?.id ?? 0
                            vc.delegate = self
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        cell.isFontBold = false
                    }
                default:
                    cell.labelTitle.textColor = .black
                }
            }
            return cell
        } else if tableView == self.detailsTableView {
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: XIB.Names.OrderDetailsCell, for: indexPath) as! OrderDetailsCell
            
            guard let  selectedItem = orderDetails?.items?[indexPath.row]  else  {return  UITableViewCell()}
            let namePrice = calculateAddOnPrice(items: selectedItem)
            cell.labelAddOns.text = namePrice.0
            cell.labelAddOns.isHidden = namePrice.0.count == 0
            
            var productPrice = (orderDetails?.items?[indexPath.row].product?.prices!.price)! * Double((orderDetails?.items?[indexPath.row].quantity)!)
       //     let  addOnsPrice = (namePrice.1 * Double(orderDetails?.items?[indexPath.row].quantity ?? 0)) * Double(orderDetails?.items![indexPath.row].product.)
            
            productPrice = Double(productPrice )  + (namePrice.1 * Double(orderDetails?.items?[indexPath.row].quantity ?? 0))
            cell.labelPrice.text = Common.showAmount(amount: productPrice )
            cell.labelProduct.text = (selectedItem.product?.name ?? "") + " x " + "\(selectedItem.quantity ?? 0)"
            cell.isVegOrNon = (selectedItem.product?.food_type == VEGORNONVEG().veg ? true : false)
            return cell
          }else if tableView == self.helpTableView {
            let cell = helpTableView.dequeueReusableCell(withIdentifier: XIB.Names.HelpCell, for: indexPath)
            guard let dispute = self.disputeArr?[indexPath.row] else {
                return UITableViewCell()
            }
            Common.setFont(to: cell.textLabel ?? UILabel(), isTitle: false, size: 15, fontType: .regular)
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = dispute.name
            return cell
          } else {
             return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.helpTableView {
            guard let selectedDispute = self.disputeArr?[indexPath.row] else {
                return
            }
            let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.HelpViewController) as! HelpViewController
            vc.dispute = selectedDispute
            vc.ItemDetail = self.labelItems.text
            vc.orderNumber = self.labelOrderNumber.text
            vc.orderID = orderDetails?.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setPastOrderImage(image:UIImageView) {
        let imageName = orderDetails?.status == OrderStatus.CANCEL.rawValue ? "ic_cancelled" : "cellSelect"
        image.image = UIImage(named: imageName)
        if orderDetails?.status ?? "" == OrderStatus.CANCEL.rawValue || orderDetails?.status ?? "" == OrderStatus.COMPLETED.rawValue  {
             image.isHidden  =  false
        }  else {
             image.isHidden = true
        }
    }
    
    func setOrderHeader(label:UILabel) {
        Common.setFont(to: label, isTitle: false, size: 12, fontType: .regular)
        switch orderDetails?.status {
        case OrderStatus.COMPLETED.rawValue : label.text = APPLocalize.localizestring.delivered.localize() + (orderDetails?.delivery_date ?? "")
        label.textColor = .greenColor
        case OrderStatus.CANCEL.rawValue : label.text = APPLocalize.localizestring.orderCancel.localize()
        label.textColor = .red
        default : label.text = "#000\(orderDetails?.id ?? 0)"
        Common.setFont(to: label, isTitle: false, size: 16, fontType: .bold)
        }
    }
    
    func calculateAddOnPrice(items:Items) -> (String,Double) {
        var addOnName = ""
        var addOnPrice:Double = 0
        if items.cart_addons?.count ?? 0 > 0 {
            for addOns in items.cart_addons ?? [Cart_addons]() {
                addOnName = addOnName + (addOns.addon_product?.addon?.name ?? "") + ","
                addOnPrice = (addOns.addon_product?.price ?? 0) * Double(addOns.quantity ?? 0)
            }
            if addOnName.count > 0 {
                addOnName = String(addOnName.dropLast())
            }
        }
        return (addOnName,addOnPrice)
    }
    
    

}


extension OrderTrackingViewController {
    
    @objc func detailsClickEvent(sender: UIButton) {
        isFirstSelect = true
        isHelpTableShow = false
        helpDividerLine.backgroundColor = .white
    }
    
    @objc func helpClickEvent(sender: UIButton) {
        isFirstSelect = false
        isHelpTableShow = true
        helpDividerLine.backgroundColor = .secondary
        self.helpTableView.reloadInMainThread()
    }
}

//MARK: - Google Map

extension OrderTrackingViewController:GMSMapViewDelegate {
    func drawPolyline(){
        self.mapView.drawPolygon(from: CLLocationCoordinate2D(latitude: orderDetails?.shop?.latitude ?? 0.0, longitude: orderDetails?.shop?.longitude ?? 0.0), to: CLLocationCoordinate2D(latitude: orderDetails?.address?.latitude ?? 0.0, longitude: orderDetails?.address?.longitude ?? 0.0))
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
    func moveProviderMarker() {
        guard let transporterLat = orderDetails?.transporter?.latitude,let transporterLong = orderDetails?.transporter?.longitude else{
            return
        }
        
        let location:LocationCoordinate = CLLocationCoordinate2D(latitude: transporterLat, longitude: transporterLong)
        if driverMarker.map == nil {
            driverMarker.map = self.mapView
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(3)
        driverMarker.position = location
        CATransaction.commit()
        self.driverLastLocation = location
    }
    
    
    

}

extension OrderTrackingViewController:PostViewProtocol {
   
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getOrders(api: Base, data: OrderList?) {
        if data != nil {
            if isCancelOrder {
                Common.showToast(string: APPLocalize.localizestring.orderCancel.localize())
//                self.popOrDismiss(animation: true)
                
                let baseHomeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController)
                self.navigationController?.pushViewController(baseHomeVC, animated: true)
            }
            orderDetails = data
            self.tableView.reloadInMainThread()
        }
    }
    
    
    
    func getDisputeList(api: Base, data: [Dispute]?) {
        if data?.count ?? 0 > 0 {
            self.disputeArr = data
        }
        self.helpTableView.reloadInMainThread()
    }
    
}

extension OrderTrackingViewController: FeedBackPopViewViewControllerDelegate {
    func FeedBackNextScreen() {
        
        let baseHomeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController)
        self.navigationController?.pushViewController(baseHomeVC, animated: true)
    }
}

extension Array {
    func indexesOf<T : Equatable>(object:T) -> Int {
        var result: [Int] = []
        for (index,obj) in self.enumerated() {
            if obj as! T == object {
                result.append(index)
                return index
            }
        }
        return 100
    }
}
