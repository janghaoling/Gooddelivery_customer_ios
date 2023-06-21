//
//  SearchForResturantDishesController.swift
//  Project
//
//  Created by CSS on 16/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class SearchForResturantDishesController: UIViewController {
    
    @IBOutlet weak var dishesTableView: UITableView!
    @IBOutlet weak var resturantTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resturantDividerLine: UIView!
    @IBOutlet weak var dishesDividerLine: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tableContainView: UIView!
    @IBOutlet weak var dishLbl: UIButton!
    @IBOutlet weak var restBut: UIButton!
    
    var searchList: SearchProduct?
    var shopList = [Shops]()
    var productList = [Products]()
    
    var addCart: AddCart?
    private var cartId = 0
    private var quantity = 0
    private var productId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(true)
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
    }
    
    func localize() {
        searchBar.placeholder = APPLocalize.localizestring.searchForResturant.localize()
        restBut.setTitle(APPLocalize.localizestring.resturant.localize(), for: .normal)
        dishLbl.setTitle(APPLocalize.localizestring.dishes.localize(), for: .normal)
    }
    
    func setCustomFont() {
        Common.setFont(to: restBut, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: dishLbl, isTitle: true, size: 14, fontType: .semiBold)
    }
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
    
    //MARK:- Initial Loads
    
    private func initialLoads(){
        
        self.dishesTableView.reloadData()
        self.resturantTableView.reloadData()
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
        self.searchBar.showsCancelButton = true

        localize()
        setCustomFont()
        dishesTableView.register(UINib(nibName: XIB.Names.DishesListCell, bundle: nil), forCellReuseIdentifier: XIB.Names.DishesListCell)
        dishesTableView.separatorStyle = .none
        resturantTableView.register(UINib(nibName: XIB.Names.OrderListCell, bundle: nil), forCellReuseIdentifier: XIB.Names.OrderListCell)
        resturantTableView.separatorStyle = .none
        dishesTableView.isHidden = true
        resturantTableView.isHidden = false
        resturantDividerLine.isHidden = false
        dishesDividerLine.isHidden = true
        resturantTableView.reloadData()
    }
    
    @IBAction func resturantBasedSearch(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0) {
            self.dishesTableView.isHidden = true
            self.resturantTableView.isHidden = false
            self.resturantDividerLine.isHidden = false
            self.dishesDividerLine.isHidden = true
            self.resturantTableView.reloadData()
        }
    }
    
    @IBAction func dishesBasedSearch(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0) {
            self.dishesTableView.isHidden = false
            self.resturantTableView.isHidden = true
            self.resturantDividerLine.isHidden = true
            self.dishesDividerLine.isHidden = false
            self.dishesTableView.reloadData()
        }
    }
}

//MARK:- Methods

extension SearchForResturantDishesController {
    func reloadTable() {
        DispatchQueue.main.async {
            self.dishesTableView.reloadData()
            self.resturantTableView.reloadData()
        }
    }
}

//MARK:- UISearchBarDelegate

extension SearchForResturantDishesController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            shopList.removeAll()
            productList.removeAll()
            reloadTable()
        }else{
            callSearchAPI()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        shopList.removeAll()
        productList.removeAll()
        reloadTable()
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    func callSearchAPI() {
        self.searchList = SearchProduct()
        searchList?.name = searchBar.text
        searchList?.user_id = User.main.id
        self.presenter?.get(api: .searchProduct, data: searchList?.toData())
    }
}


//MARK: - TableView Delegate & Datasource
extension SearchForResturantDishesController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         if tableView.tag == 0 {
            return 1
        }else{
            return productList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return (shopList.count)
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {        if tableView.tag == 0 {
            if (searchBar.text?.count)! <= 0 {
                return ""
            }else{
                return APPLocalize.localizestring.relatedTo.localize()+"\(searchBar.text!)"
            }
        }else{
            return productList[section].shop?.name?.uppercased()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         if tableView.tag == 0 {
            if (searchBar.text?.count)! <= 0 {
                return 0
            }
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            Common.setFont(to: label, isTitle: true, size: 14, fontType: .regular)
            label.textColor = UIColor.black
            
            if (searchBar.text?.count)! <= 0 {
                label.text =  ""
            }else{
                label.text =  APPLocalize.localizestring.relatedTo.localize()+"\(searchBar.text!)"
            }
            headerView.addSubview(label)
            
            return headerView
        }else{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            Common.setFont(to: label, isTitle: true, size: 14, fontType: .regular)
            label.textColor = UIColor.black
            
            label.text = productList[section].shop?.name?.uppercased()
            headerView.addSubview(label)
            
            return headerView
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == resturantTableView {
//            return 120
//        } else {
//            return 130
//        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(for: indexPath, in: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
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
    
    private func getCell(for indexPath : IndexPath, in tableView : UITableView)->UITableViewCell {
        
       if tableView.tag == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.OrderListCell, for: indexPath) as? OrderListCell {
                cell.set(values: shopList[indexPath.row])
                return cell
            }
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.DishesListCell, for: indexPath) as? DishesListCell {
                cell.btnMinus.tag = indexPath.section
                cell.btnPlus.tag = indexPath.section
                cell.btnAdd.tag = indexPath.section
                cell.btnViewFullMenu.tag = indexPath.section
                cell.set(values: productList[indexPath.section])
                cell.btnPlus.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
                cell.btnMinus.addTarget(self, action: #selector(removeFromCart(sender:)), for: .touchUpInside)
                cell.btnViewFullMenu.addTarget(self, action: #selector(viewFullMenuAction), for: .touchUpInside)

                cell.btnAdd.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension SearchForResturantDishesController:PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        showToast(string: ErrorMessage.list.nosearchresult)
    }
    func searchProduct(api: Base, data: SearchProducts?) {
        shopList = (data?.shop)!
        productList = (data?.products)!
        self.reloadTable()
    }
    //Callback for addCart
    func addCart(api: Base, data: CartList?) {
        
        if api == .addCart, data != nil {
           callSearchAPI()
            LoadingIndicator.hide()
        }
    }
}

extension SearchForResturantDishesController {
    
    @objc func viewFullMenuAction(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to:self.dishesTableView)
        if let indexPath = dishesTableView.indexPathForRow(at: point) {
            if productList.count > indexPath.section {
                
                let shopListEntity = productList[indexPath.section]
                if shopListEntity.shopstatus == SHOPSTATUS().open {
                    let redirectTest = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ResturantMenuListViewController) as! ResturantMenuListViewController
                    redirectTest.shop = shopListEntity.shop_id
                    redirectTest.shopList = shopListEntity.shop
                    
                    self.navigationController?.pushViewController(redirectTest, animated: true)
                } else {
                    
                    self.showToast(string: APPLocalize.localizestring.shopClosed.localize())
                }
            }
        }
    }
    
    @objc func addToCart(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to:self.dishesTableView)
        if let indexPath = dishesTableView.indexPathForRow(at: point) {
            
            if User.main.id != nil {
                let productEntity = productList[indexPath.section]
                
                if productEntity.id != nil {
                    self.productId = productEntity.id!
                }
                
                if (productEntity.cart?.count)! > 0 {
                    
                    if productEntity.cart?[0].id != nil, productEntity.cart?[0].quantity != nil {
                        self.cartId = (productEntity.cart?[0].id)!
                        self.quantity = (productEntity.cart?[0].quantity)! + 1
                    }
                } else {
                    
                    self.quantity = 1
                }
                
                self.addCart = AddCart()
                self.addCart?.quantity = self.quantity
                self.addCart?.cart_id = self.cartId
                self.addCart?.product_id = self.productId
                LoadingIndicator.show()
                self.presenter?.post(api: .addCart, data: self.addCart?.toData())

            } else {
                let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
                self.navigationController?.pushViewController(signIn, animated: true)
            }
            
        }
    }
    
    @objc func removeFromCart(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to:self.dishesTableView)
        if let indexPath = dishesTableView.indexPathForRow(at: point) {
            
            if User.main.id != nil {
                
                    let productEntity = productList[indexPath.section]
                
                    if productEntity.id != nil {
                        self.productId = productEntity.id!
                    }
                    
                    if (productEntity.cart?.count)! > 0 {
                        
                        if productEntity.cart?[0].id != nil, productEntity.cart?[0].quantity != nil {
                            self.cartId = (productEntity.cart?[0].id)!
                            self.quantity = (productEntity.cart?[0].quantity)! - 1
                        }
                    } else {
                        
                        self.quantity = 0
                    }
                    
                    self.addCart = AddCart()
                    self.addCart?.quantity = self.quantity
                    self.addCart?.product_id = self.productId
                    self.addCart?.cart_id = self.cartId
                    self.addCart?.addons_qty = []
                    self.addCart?.product_addons = []
                    LoadingIndicator.show()
                    self.presenter?.post(api: .addCart, data: self.addCart?.toData())
                
            } else {
                let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
                self.navigationController?.pushViewController(signIn, animated: true)
            }
        }
    }
}
