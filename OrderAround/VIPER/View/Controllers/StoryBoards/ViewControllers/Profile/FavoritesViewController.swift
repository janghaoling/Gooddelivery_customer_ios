//
//  FavoritesViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableViewFavourites: UITableView!
    var sectionHeaderHeight: CGFloat = 55
    var availableFavourites:[FavouriteShop] = []
    var unAvailableFavourites:[FavouriteShop] = []
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loader.isHideInMainThread(false)
        self.presenter?.get(api: .getFavourite, data: nil)
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Methods

extension FavoritesViewController {
    private func initialLoads() {
        tableViewFavourites.register(UINib(nibName: XIB.Names.CartResturant, bundle: nil), forCellReuseIdentifier: XIB.Names.CartResturant)
        tableViewFavourites.separatorStyle = .none
        setFont_localize()
    }
    
    private func setFont_localize() {
        Common.setFont(to: labelTitle, isTitle: true, size: 17, fontType: .bold)
        self.labelTitle.text = APPLocalize.localizestring.favorites.localize().uppercased()
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch  indexPath.section {
        case 0:
            return availableFavourites.count > 0 ?  70 : 0
        case 1:
            return unAvailableFavourites.count > 0 ?  70 : 0
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return availableFavourites.count > 0 ?  availableFavourites.count : 0
        case 1:
            return unAvailableFavourites.count > 0 ?  unAvailableFavourites.count : 0
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeight)
        headerView.backgroundColor = .white
        let headerLbl = UILabel()
        headerLbl.frame = CGRect(x: 15, y: 0, width: tableView.frame.width - (2 * 20), height: 25)
        if section == 0 {
            headerLbl.text = APPLocalize.localizestring.currentlyAvailble.localized
        } else {
            headerLbl.text = APPLocalize.localizestring.currentlyAvailble.localized
        }
        Common.setFont(to: headerLbl, size : 14, fontType : FontCustom.semiBold)
        headerLbl.textAlignment = .left
        headerView.addSubview(headerLbl)
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return availableFavourites.count > 0 ?  sectionHeaderHeight : 0
        case 1:
            return unAvailableFavourites.count > 0 ? sectionHeaderHeight : 0
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableViewFavourites.dequeueReusableCell(withIdentifier: XIB.Names.CartResturant, for: indexPath) as! CartResturant
            
            if availableFavourites.count > 0 && availableFavourites.count > indexPath.row {
                
                let shopDetail = availableFavourites [indexPath.row]
                cell.shopDescriptionLbl.text = shopDetail.shop?.description
                cell.shopImage.setImage(with: shopDetail.shop?.avatar, placeHolder: #imageLiteral(resourceName: "restaurant_placeholder"))
                cell.shopNameLbl.text = shopDetail.shop?.name
            }
            return cell
        case 1:
            let cell = tableViewFavourites.dequeueReusableCell(withIdentifier: XIB.Names.CartResturant, for: indexPath) as! CartResturant
            if unAvailableFavourites.count > 0 && unAvailableFavourites.count > indexPath.row {
                
                let shopDetail = unAvailableFavourites [indexPath.row]
                cell.shopDescriptionLbl.text = shopDetail.shop?.description
                cell.shopImage.setImage(with: shopDetail.shop?.avatar, placeHolder: #imageLiteral(resourceName: "restaurant_placeholder"))
                cell.shopNameLbl.text = shopDetail.shop?.name
            }
            return cell
        default:
            let cell = tableViewFavourites.dequeueReusableCell(withIdentifier: XIB.Names.CartResturant, for: indexPath) as! CartResturant
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let shopListEntity = availableFavourites[indexPath.row]
            let redirectTest = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ResturantMenuListViewController) as! ResturantMenuListViewController
            redirectTest.shop = shopListEntity.shopId
            redirectTest.shopList = shopListEntity.shop
            redirectTest.IsFav = 1
            print(shopListEntity)
            self.navigationController?.pushViewController(redirectTest, animated: true)
            
        case 1:
            Common.showToast(string: APPLocalize.localizestring.shopUnAvilable.localize())
        default:
            return
        }
    }
}


extension FavoritesViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHideInMainThread(true)
        Common.showToast(string: message)
    }
    
    func getFavoriteList(api: Base, data: FavouriteList?) {
        if api == .getFavourite, data != nil {
            availableFavourites = data?.available ?? []
            unAvailableFavourites = data?.un_available  ?? []
            if availableFavourites.count == 0 && unAvailableFavourites.count == 0 {
                self.tableViewFavourites.setBackgroundImageAndTitle(imageName: EmptyImage.favEmpty.rawValue, title: APPLocalize.localizestring.favEmptyHeading.localize().uppercased(), description: APPLocalize.localizestring.favEmptyContent.localize())
            }
            tableViewFavourites.reloadInMainThread()
            self.loader.isHideInMainThread(true)
        }
    }
    
}
