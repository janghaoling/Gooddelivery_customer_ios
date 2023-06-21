//
//  UserAccountViewController.swift
//  Project
//
//  Created by CSS on 18/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController {

    //MARK: - Declarations.
    @IBOutlet weak var labelLoginAccount: UILabel!
    @IBOutlet weak var labelLoginMessage : UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelUserDetails: UILabel!
    
    @IBOutlet weak var tableUserAccount: UITableView!
    @IBOutlet weak var imageProfile: UIImageView!
   
    @IBOutlet weak var buttonEdit:UIButton!
    
    @IBOutlet weak var viewTop:UIView!
    @IBOutlet weak var viewLogin:UIView!
    
    var sectionHeaderHeight: CGFloat = 55
    var sectionFooterHeight: CGFloat = 40
    var menuImg = [#imageLiteral(resourceName: "ic_home_unselect"),#imageLiteral(resourceName: "fav-unselected"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "order"),#imageLiteral(resourceName: "promotion"),#imageLiteral(resourceName: "password"),#imageLiteral(resourceName: "countrychange")]
    let showMenuBut = UIButton()
    @IBOutlet weak var loginButton: UIButton!
    
    var isTapped = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                UIView.setAnimationsEnabled(false)
                self.tableUserAccount.beginUpdates()
                self.tableUserAccount.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
                self.tableUserAccount.endUpdates()
                self.reloadWithAnimation()
            }
        }
    }
    
    var isLoggedin = true {
        didSet {
            viewLogin.isHidden = isLoggedin
            viewTop.isHidden = !isLoggedin
            !isLoggedin ?  self.tableUserAccount.setBackgroundImageAndTitle(imageName: EmptyImage.cartEmpty.rawValue, title: APPLocalize.localizestring.goodFoodIsAlwaysGettingCooked.localize(), description: APPLocalize.localizestring.pleaseLoginAndOrder.localize()) :  nil
        }
    }
    
    var accountDetails = [APPLocalize.localizestring.manageAdress.localize(),APPLocalize.localizestring.favorites.localize(),APPLocalize.localizestring.payment.localize(), APPLocalize.localizestring.myOrder.localize().uppercased(),APPLocalize.localizestring.promoDetails.localize(),APPLocalize.localizestring.changePassword.localize(),APPLocalize.localizestring.changeLanguage.localize()]
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    //MARK: - ViewLife cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if User.main.id != nil {
            isLoggedin = true
            gettingUserProfileInfo()
        } else {
            isLoggedin = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageProfile.makeRoundedCorner()
    }
  
}

//MARK: - StringLocalize & Font design
extension UserAccountViewController {
    
    func localize() {
        loginButton.setTitle(APPLocalize.localizestring.login.localize(), for: .normal)
        buttonEdit.setTitle(APPLocalize.localizestring.edit.localize(), for: .normal)
    }
    
    func setFont() {
        Common.setFont(to: labelUsername, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: labelUserDetails, isTitle: true, size: 12, fontType: .regular)
        Common.setFont(to: loginButton, isTitle: true, size: 17, fontType: .semiBold)
        Common.setFont(to: buttonEdit, isTitle: false, size: 14, fontType: .regular)
    }
    
    private func initialLoads() {
        localize()
        setFont()
        tableUserAccount.separatorStyle = .none
        tableUserAccount.register(UINib(nibName: XIB.Names.AccountDetails, bundle: nil), forCellReuseIdentifier: XIB.Names.AccountDetails)
        tableUserAccount.register(UINib(nibName: XIB.Names.LogoutCell, bundle: nil), forCellReuseIdentifier: XIB.Names.LogoutCell)
        loginButton.addTarget(self, action: #selector(redirectToSignIn), for: .touchUpInside)
        buttonEdit.addTarget(self, action: #selector(tapEditProfile), for: .touchUpInside)
        buttonEdit.setTitleColor(.secondary, for: .normal)
    }
}

//MARK: - Button actions
extension UserAccountViewController {
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
    @objc func redirectToSignIn(sender: UIButton) {
      
        let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
        self.navigationController?.pushViewController(signIn, animated: true)
    }

    @objc func showHiddenMenu(sender: UIButton) {
      
        isTapped = !isTapped
    }
    
    @IBAction func tapEditProfile() {
        self.push(id: Storyboard.Ids.EditProfileViewController, animation: true)
    }
    
}

//MARK: UITableViewDelegate & UITableViewDataSource

extension UserAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return accountDetails.count
        case 1:
            return 1
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoggedin ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeaderHeight)
            headerView.backgroundColor = .white
            let headerLbl = UILabel()
            headerLbl.frame = CGRect(x: 15, y: 0, width: tableView.frame.width - (2 * 25), height: 25)
            headerLbl.text = APPLocalize.localizestring.myAccount.localize()
            Common.setFont(to: headerLbl, size : 14, fontType : FontCustom.semiBold)
            headerLbl.textAlignment = .left
            headerView.addSubview(headerLbl)
            let arrowImage =  UIImageView(frame: CGRect(x: headerLbl.frame.width, y: 0, width: 18, height: 18))
            arrowImage.image = isTapped ? UIImage(named: "ic_up_arrow") : UIImage(named: "ic_down_arrow")
            arrowImage.imageTintColor(color1: .secondary)
            headerView.addSubview(arrowImage)
            
            let detailsLbl = UILabel()
            detailsLbl.frame = CGRect(x: 15, y: headerLbl.frame.maxY, width: tableView.frame.width - (2 * 20), height: 25)
            detailsLbl.text = APPLocalize.localizestring.menuDetails.localize()
            Common.setFont(to: detailsLbl, size : 12, fontType : FontCustom.regular)
            detailsLbl.textColor = UIColor.lightGray
            detailsLbl.textAlignment = .left
            headerView.addSubview(detailsLbl)
            
            showMenuBut.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
            showMenuBut.addTarget(self, action: #selector(showHiddenMenu), for: .touchUpInside)
            headerView.addSubview(showMenuBut)
            
            return headerView
            
        case 1:
            
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionFooterHeight)
            headerView.backgroundColor = UIColor(hex: "#F6F6F6")
            return headerView
            
        default:
            
            let headerView = UIView()
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return sectionHeaderHeight
        case 1:
            return sectionFooterHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section) {
        case 0:
            return (indexPath.row == 5 &&  User.main.login_by != LoginType.manual) ? 0 : isTapped  ?  0 :  50
//            if  {
//                 return 0
//            } else {
//                return 50
//            }
        case 1:
            return 150
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AccountDetails, for: indexPath) as! AccountDetails
            if accountDetails.count > 0 && accountDetails.count > indexPath.row {
                cell.labelTitle.text = accountDetails[indexPath.row]
                cell.imageAccount.image = menuImg[indexPath.row]
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.LogoutCell, for: indexPath) as! LogoutCell
            cell.labelTitle.text = APPLocalize.localizestring.logout.localize().uppercased()
            cell.labelAppVersion.text = APPLocalize.localizestring.appVersion.localize() + " " + Bundle.main.getVersion()
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AccountDetails, for: indexPath) as! AccountDetails
            
            return cell
        }
        
    }
    private func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animation(fromLeft: cell.contentView)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let manageAddress = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ManageAddressViewController) as! ManageAddressViewController
            self.navigationController?.pushViewController(manageAddress, animated: true)
        case (0,1):
            let favorites = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.FavoritesViewController) as! FavoritesViewController
            self.navigationController?.pushViewController(favorites, animated: true)
        case (0,2):
            let payment = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PamentListViewController) as! PamentListViewController
            payment.isFromCartFlow = false
            self.navigationController?.pushViewController(payment, animated: true)
        case (0,3):
            let order = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.MyOrdersViewController) as! MyOrdersViewController
            self.navigationController?.pushViewController(order, animated: true)
        case (0,4):
            let promo = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.PromoCodeViewController) as! PromoCodeViewController
            self.navigationController?.pushViewController(promo, animated: true)
        case (0,5):
            let changePassword = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ChangePasswordController) as! ChangePasswordController
            self.navigationController?.pushViewController(changePassword, animated: true)
        case (0,6):
            let changeLanguage = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ChangeLanguageViewController) as! ChangeLanguageViewController
            self.navigationController?.pushViewController(changeLanguage, animated: true)
            
        case (1,0):
            self.alertControllerPresentEvent()
            
        default:
            break
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        UIView.animate(withDuration: 0.4) {
//            cell.transform = CGAffineTransform.identity
//        }
   // }
    
    func reloadWithAnimation() {
//        self.reloadData()
        let tableViewHeight = self.tableUserAccount.bounds.size.height
        let cells = self.tableUserAccount.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

// MARK: - gettingUser ProfileInfo
extension UserAccountViewController {
    
    func gettingUserProfileInfo() {
        
        DispatchQueue.main.async {
            self.labelUsername.text = User.main.name
            let email: String = User.main.email ?? Constants.string.empty
            let phoneNumber: String = User.main.mobile ?? Constants.string.empty
            self.labelUserDetails.text = phoneNumber + ", " + email
            self.imageProfile.setImage(with: User.main.picture, placeHolder: #imageLiteral(resourceName: "userPlaceholder"))
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
       
    }
}

//MARK: - Alert controller present event.
extension UserAccountViewController {

    func alertControllerPresentEvent() {
        
        let alert = UIAlertController(title: Constants.string.empty.localize(), message:  APPLocalize.localizestring.areYouSureWantToLogout.localize(), preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: APPLocalize.localizestring.logout.localize(), style: .default, handler: { action in
            self.logoutTheUserFromApp()
            
        }))
        
        alert.addAction(UIAlertAction(title: APPLocalize.localizestring.Cancel.localize(), style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Button Actions.
    
    func logoutTheUserFromApp() {
        
        clearUserDefaults()
//        let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
//        self.navigationController?.pushViewController(signIn, animated: true)
        forceLogout()
        let userDefaults = UserDefaults.standard
        userDefaults.set(0, forKey: "promoCodeId")
        
    }
}
