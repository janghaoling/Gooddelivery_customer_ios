//
//  ManageAddressViewController.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {
    
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    var headerHeight: CGFloat = 55
      
    @IBOutlet weak var tableView: UITableView!
    var  orderDataSource = [String:[OrderList]]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shimmerView.isHidden = false
        localize()
        tableView.register(UINib(nibName: XIB.Names.MyOrdersCell, bundle: nil), forCellReuseIdentifier: XIB.Names.MyOrdersCell)
     
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.get(api: .onGoingOrders, data: nil)
        addRefreshControl()

    }
    func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.presenter?.get(api: .onGoingOrders, data: nil)
    }
    
    private func localize() {
        labelTitle.text = APPLocalize.localizestring.order.localize()
        Common.setFont(to: labelTitle, isTitle: true, size: 15, fontType: .semiBold)
    }
    
    @IBAction func backToPrevious(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // return onGoing.count > 0 ? 1 : 0//self.dataSource.count > 0 ? dataSource.count : 0
        return orderDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let data = orderDataSource  else { return 0 }
        return Array(orderDataSource.values)[section].count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190 //UITableViewAutomaticDimension
    }
    
    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return self.tableView.headerView(height: headerHeight, text:Array(orderDataSource.keys)[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.MyOrdersCell, for: indexPath) as! MyOrdersCell
        print(orderDataSource.values.count)
        print(indexPath.row)
        cell.delegate = self
        if Array(orderDataSource.keys)[indexPath.section] == APPLocalize.localizestring.currentOrders.localize() {
            cell.setValues(values: Array(orderDataSource.values)[indexPath.section][indexPath.row])
        }else{
            cell.setValues(values: Array(orderDataSource.values)[indexPath.section][indexPath.row])
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderType = Array(orderDataSource.keys)[indexPath.section]
        let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.OrderTrackingViewController) as! OrderTrackingViewController
        vc.isPastOrder = orderType == APPLocalize.localizestring.pastOrders.localize().uppercased()
        vc.isFromMyOrder = true
        vc.orderDetails = Array(orderDataSource.values)[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MyOrdersViewController : PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        refreshControl.endRefreshing()
        Common.showToast(string: message)
        self.shimmerView.isHidden = true
    }
    func getOnGoingOrder(api: Base, data: [OrderList]?) {
        refreshControl.endRefreshing()
        if api == .onGoingOrders {
            if data?.count ?? 0 > 0 {
                orderDataSource[APPLocalize.localizestring.currentOrders.localize().uppercased()] = data ?? []
            }
            print("Ongoing \(orderDataSource)")
            self.presenter?.get(api: .pastOrders, data: nil)
        }else if api == .pastOrders{
            if data?.count ?? 0 > 0 {
                orderDataSource[APPLocalize.localizestring.pastOrders.localize().uppercased()] = data ?? []
            }
            print("Past \(orderDataSource)")
            setUpTable()
        }
    }
    
    func setUpTable() {
        self.shimmerView.isHidden = true
        guard self.orderDataSource.count > 0 else {
            self.tableView.setBackgroundImageAndTitle(imageName: EmptyImage.orderEmpty.rawValue, title: APPLocalize.localizestring.orderEmptyHead.localize(), description: APPLocalize.localizestring.orderEmptyContent.localize())
            return
        }
        self.tableView.reloadInMainThread()
    }
}

extension MyOrdersViewController: MyOrderDetailDelegate{
    func pushtocartViewController(data: OrderList) {
        if data.shop_id != User.main.cart?.first?.id {//User.main.cart?.first?.product?.shop_id {
            showAlert(message: APPLocalize.localizestring.anotherRestaurant.localize(), okHandler: {
                self.reorderAPI(data: data)
            }, fromView: self)
        }else if data.id == User.main.cart?.first?.id {
            showAlert(message: APPLocalize.localizestring.anotherDishesSameRestaurant.localize(), okHandler: {
                self.reorderAPI(data: data)
            }, fromView:  self)
        }else{
            self.reorderAPI(data: data)
        }
    }
    
    func reorderAPI(data: OrderList) {
        var reorder = Reorder()
        reorder.order_id = data.id
        self.presenter?.post(api: .reOrder, data: reorder.toData())
    }
}

extension MyOrdersViewController {
    
    func getReorder(api: Base, data: Carts?) {
        let cartVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CartViewController) as! CartViewController
        cartVC.isFromResturantCart = true
        
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
}


