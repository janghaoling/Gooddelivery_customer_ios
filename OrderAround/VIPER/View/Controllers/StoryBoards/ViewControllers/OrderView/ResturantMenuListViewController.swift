//
//  ResturantMenuListViewController.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import ParallaxHeader
import FaveButton


public struct VEGORNONVEG {
    
    let veg =  "veg"
    let nonVeg = "non-veg"
}

class ResturantMenuListViewController: UIViewController {
    
    //MARK: - Declarations.
    @IBOutlet weak var cartShowButton: UIButton!
    @IBOutlet weak var dividerLine: UIView!
    @IBOutlet weak var tableView: UITableView!
    weak var headerImageView: UIView?
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var addFavorties: FaveButton!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var resturantNameLbl: UILabel!
    @IBOutlet weak var viewCartLbl: UILabel!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var cartItemView: UIView!
    @IBOutlet weak var cartItemShopName: UILabel!

    @IBOutlet weak var backIconView: UIView!
    var lastContentOffset: CGFloat = 0
    var headerHeight: CGFloat = 55
    var catgories: CategoriesList?
    var featuredProducts = [Featured_products]()
    var categoriesArray = [Categories]()
    var productTitleArray = [String]()
    var numberofSection:Int = 0
    private var featureSectionsList = 1
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    var IsFav = 0
    var shop:Int?
    let headerLbl = UILabel()
    var shopList: Shops!
    var doFav: DoFavourites?
    var addCart: AddCart?
    private var cartId = 0
    private var quantity = 0
    private var productId = 0
    
    var sectionValue: Int?
    var selectedIndexPath = 0
    var cartCount: Int = 0
    var cartShopId: Int = 0
    
    @IBOutlet weak var backButton: UIButton!
    
    //MARK - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.cartItemView.bounds.height, 0)
        backIconView.layer.cornerRadius = backIconView.frame.width/2
      //  let imgOriginal = UIImage(named: "back1")
      //  backButton.setImage(imgOriginal, for: .normal)
        cartItemView.isHidden = true
        loader.isHidden = false
        localize()
        categoriesList()
        cartList()
        setupParallaxHeader()
        tableView.register(UINib(nibName: XIB.Names.ResturantRatingCell, bundle: nil), forCellReuseIdentifier: XIB.Names.ResturantRatingCell)
        tableView.register(UINib(nibName: XIB.Names.AddCartCell, bundle: nil), forCellReuseIdentifier: XIB.Names.AddCartCell)
        tableView.register(UINib(nibName: XIB.Names.AddCartWithImgView, bundle: nil), forCellReuseIdentifier: XIB.Names.AddCartWithImgView)
        tableView.register(UINib(nibName: XIB.Names.SectionHeaderCell, bundle: nil), forCellReuseIdentifier: XIB.Names.SectionHeaderCell)
        //tableView.register(UINib(nibName: XIB.Names.SectionHeaderCell, bundle: nil), forCellReuseIdentifier: "sectionHeaderCell")
        tableView.separatorStyle = .none
        
      //  cartViewAnimHide()
        
        if shopList.favorite != nil {
            addFavorties.setSelected(selected: true, animated: true)
        } else {
            addFavorties.setSelected(selected: false, animated: true)
        }
        
        if IsFav == 1 {
            addFavorties.setSelected(selected: true, animated: true)
        }
        resturantNameLbl.text = shopList.name
        cartShowButton.addTarget(self, action: #selector(moveToCartView), for: .touchUpInside)
        addFavorties.addTarget(self, action: #selector(addShopToFavortiesList), for: .touchUpInside)
     //addFavorties.layer.borderWidth = 1
    }
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    //MARK: actions
    
    @objc private func imageDidTap(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if self.tableView.parallaxHeader.height == 400 {
                self.tableView.parallaxHeader.height = 200
                
            } else {
                self.tableView.parallaxHeader.height = 400
            }
        }
    }
}

 //MARK: setupParallaxHeader

extension ResturantMenuListViewController {
       
    private func setupParallaxHeader() {
        
        let imageView = UIImageView()
        imageView.setImage(with: shopList?.avatar, placeHolder: #imageLiteral(resourceName: "restaurant_placeholder"))
        imageView.contentMode = .scaleAspectFill
        
        headerImageView = imageView
        
        tableView.parallaxHeader.view = imageView
        tableView.parallaxHeader.height = 250
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .centerFill
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            //update alpha of blur view on top of image view
            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
        }

        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView.addSubview(backView)
        backView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        backView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        backView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0).isActive = true
        backView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0).isActive = true
        // Label for vibrant text
        let titleLbl = UILabel()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(titleLbl)
        let descriptionLbl = UILabel()
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(descriptionLbl)

        titleLbl.text = shopList.name
        Common.setFont(to: titleLbl, isTitle: true, size: 16, fontType: .semiBold)
        titleLbl.textAlignment = .left
        titleLbl.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10).isActive = true
      //  titleLbl.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant:-10).isActive = true
       // titleLbl.bottomAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 10).isActive = true

        titleLbl.textColor = .white
        
        // Label for vibrant text
        descriptionLbl.text = shopList.description
        Common.setFont(to: descriptionLbl, isTitle: true, size: 14, fontType: .semiBold)
        descriptionLbl.textAlignment = .left
        descriptionLbl.textColor = .white
        descriptionLbl.topAnchor.constraint(equalTo: titleLbl.topAnchor, constant: 15).isActive = true
        descriptionLbl.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 10).isActive = true
        descriptionLbl.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10).isActive = true
        
        self.dividerLine.isHidden = true
        self.tableHeaderView.backgroundColor = .clear
    }
    
}

//MARK: - StringLocalize & Font design
extension ResturantMenuListViewController {
    
    func localize() {
        self.viewCartLbl.text = APPLocalize.localizestring.viewCart.localize()
        Common.setFont(to: viewCartLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: itemCountLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: cartItemShopName, isTitle: true, size: 12, fontType: .regular)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            self.dividerLine.isHidden = false
            self.tableHeaderView.backgroundColor = .white
            self.resturantNameLbl.isHidden = false
            
            let origImage = UIImage(named: "back");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            backButton.setImage(tintedImage, for: .normal)
            backButton.tintColor = UIColor.black
            backIconView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.dividerLine.isHidden = true
            self.tableHeaderView.backgroundColor = .clear
            self.resturantNameLbl.isHidden = true
        
            let origImage = UIImage(named: "back");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            backButton.setImage(tintedImage, for: .normal)
            backButton.tintColor = UIColor.white
            backIconView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        } else {
            // didn't move
        }
    }
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
}

//MARK: - UITableViewDelegate & UITableViewDatasource

extension ResturantMenuListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return featuredProducts.count > 0 ? featuredProducts.count + 2 : 0
        }  else {
            let sectionValue = section-1
            return categoriesArray.count > sectionValue ? Int.val(val: (categoriesArray[sectionValue].products?.count))+1 : 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberofSection
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 6.0
//        }
//        
//        return 1.0
//    }
    
   
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView(frame: CGRect.zero)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return 84
            } else if indexPath.row ==  1 {
                return 50
            } else {
                return 255
            }
        } else {
            if indexPath.row ==  0 {
                return 50
            } else {
                return 65
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row ==  0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.ResturantRatingCell, for: indexPath) as! ResturantRatingCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.labelDelivery.text = APPLocalize.localizestring.deliveryTime.localize()
                cell.labelRating.text =  "\(shopList.rating_status!)" + APPLocalize.localizestring.Rating.localize()
                cell.labelRatingCount.text = APPLocalize.localizestring.Rating.localize()
                
                if shopList.offer_percent != nil {
                     cell.labelOfferPercentage.isHidden = false
                     cell.labelOfferPercentage.text = APPLocalize.localizestring.flat.localize() + "\(shopList.offer_percent!)" + APPLocalize.localizestring.offOrder.localize()
                }else{
                    cell.labelOfferPercentage.isHidden = true
                }
                
                cell.labelOfferPercentage.isHidden = shopList.offer_percent == 0
                cell.imageOffer.isHidden = shopList.offer_percent == 0
                
                cell.labelRating.text = "\(shopList.rating!)" + APPLocalize.localizestring.Rating.localize()
                let dates: Int = shopList.estimated_delivery_time!
                cell.labelTime.text = "\(dates)" + APPLocalize.localizestring.mins.localize().capitalizingFirstLetter()
                
                return cell
                
            } else  if indexPath.row ==  1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SectionHeaderCell, for: indexPath) as! SectionHeaderCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.titleLbl.text = APPLocalize.localizestring.featuredProducts.localize()
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddCartWithImgView, for: indexPath) as! AddCartWithImgView
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.addButton.setTitle(APPLocalize.localizestring.add.localize().uppercased(), for: .normal)
                
                let index = indexPath.row-2
                
                if featuredProducts.count > 0 && featuredProducts.count > index {
                    
                    let productEntity = featuredProducts[index]
                    if (productEntity.images?.count)! > 0 {
                        let imageEntity = productEntity.images?.first  as! Images
                        cell.productImg.setImage(with: imageEntity.url, placeHolder: #imageLiteral(resourceName: "product_placeholder"))
                    }
                    
                    if productEntity.food_type == VEGORNONVEG().veg {
                        cell.vegOrNonVegIcon.image = #imageLiteral(resourceName: "veg")
                    } else {
                        
                        cell.vegOrNonVegIcon.image = #imageLiteral(resourceName: "nonveg")
                    }
                    
                    if Double((productEntity.prices?.price)!) > (productEntity.prices?.orignal_price)! {
                        
                         cell.priceLbl.text = (productEntity.prices?.currency)! + String(format: "%.2f",(Double(productEntity.prices?.price ?? 0.00)))
                       // cell.priceLbl.text = (productEntity.prices?.currency)! +  "\(Double((productEntity.prices?.price)!))"
                        cell.offerPriceLabel.isHidden = false
                        cell.offerPriceLabel.text = (productEntity.prices?.currency)! +  "\(Double((productEntity.prices?.orignal_price)!))"
                        print("offer price there")
                        cell.priceLbl.textColor = UIColor.lightGray
                        let attributedString = NSMutableAttributedString(string: cell.priceLbl.text!)
                        
                        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                        cell.priceLbl.attributedText = attributedString
                        
                    }else{
                        cell.priceLbl.textColor = UIColor.black
                        cell.offerPriceLabel.isHidden = true
                      
                        cell.priceLbl.text = (productEntity.prices?.currency)! + String(format: "%.2f",(Double(productEntity.prices?.price ?? 0.00)))
                        print("offer price not there")

                    }
                    cell.cartCountLbl.text = "\(Int.val(val: productEntity.cart?.first?.quantity))"
                    cell.addButton.isHidden = Int.val(val: productEntity.cart?.count)>0
                    cell.cartView.isHidden = !(Int.val(val: productEntity.cart?.count)>0)
                    cell.dishNameLbl.text = productEntity.name
                    if productEntity.addons?.count ?? 0 > 0{
                        if cell.cartView.isHidden{
                            cell.plusImage.isHidden = false
                            cell.CustomizeableLabel.isHidden = false
                        }else{
                            cell.plusImage.isHidden = true
                            cell.CustomizeableLabel.isHidden = false
                        }
                    }else{
                        cell.plusImage.isHidden = true
                        cell.CustomizeableLabel.isHidden = true
                    }
                    cell.removeCartButton.tag = indexPath.row

                    cell.addButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
                    cell.addCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
                    cell.removeCartButton.addTarget(self, action: #selector(removeFromCart), for: .touchUpInside)
                    
                    return cell
                }
            }
        }
        else {
            
            if indexPath.row ==  0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SectionHeaderCell, for: indexPath) as! SectionHeaderCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.titleLbl.text = "Categories"
                let sectionValue = indexPath.section-featureSectionsList
                if categoriesArray.count > sectionValue {
                    cell.titleLbl.text = categoriesArray[sectionValue].name
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.AddCartCell, for: indexPath) as! AddCartCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                let index = indexPath.row-1
                let sectionValue = indexPath.section-featureSectionsList
                if categoriesArray.count > sectionValue, Int.val(val: categoriesArray[sectionValue].products?.count) > index {
                    
                    let productEntity = categoriesArray[sectionValue].products?[index]
                    cell.priceLbl.text = (productEntity?.prices?.currency)! + String(format: "%.2f",(Double(productEntity?.prices?.price ?? 0.00)))
                    
                   // cell.priceLbl.text = (productEntity?.prices?.currency)! +  "\(productEntity?.prices?.price ?? 0)"
                    cell.tilteLbl.text = productEntity?.name
                    
                    if productEntity?.food_type == VEGORNONVEG().veg {
                        cell.vegIcon.image = #imageLiteral(resourceName: "veg")
                    } else {
                        
                        cell.vegIcon.image = #imageLiteral(resourceName: "nonveg")
                    }
                    
                    if Double((productEntity!.prices?.price)!) > (productEntity!.prices?.orignal_price)! {
                        
                         cell.priceLbl.text = (productEntity?.prices?.currency)! + String(format: "%.2f",(Double(productEntity?.prices?.price ?? 0.00)))
                      //  cell.priceLbl.text = (productEntity!.prices?.currency)! +  "\(Double((productEntity?.prices?.price)!))"
                        cell.offerPriceLabel.isHidden = false
                        cell.offerPriceLabel.text = (productEntity!.prices?.currency)! +  "\(Double((productEntity?.prices?.orignal_price)!))"
                        print("offer price there")
                        cell.priceLbl.textColor = UIColor.lightGray
                        let attributedString = NSMutableAttributedString(string: cell.priceLbl.text!)
                        
                        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                        cell.priceLbl.attributedText = attributedString
                        
                    }else{
                        cell.priceLbl.textColor = UIColor.black
                        cell.offerPriceLabel.isHidden = true
                         cell.priceLbl.text = (productEntity?.prices?.currency)! + String(format: "%.2f",(Double(productEntity?.prices?.price ?? 0.00)))
                       // cell.priceLbl.text = (productEntity?.prices?.currency)! +  "\(Double(productEntity?.prices?.price ?? 0.0))"
                        print("offer price not there")
                        
                    }
                    cell.cartCountLbl.text = "\(Int.val(val: productEntity?.cart?.first?.quantity))"
                    cell.cartView.isHidden = !(Int.val(val: productEntity?.cart?.count)>0)
                    cell.addCart.isHidden = (Int.val(val: productEntity?.cart?.count)>0)
         
                    if productEntity?.addons?.count ?? 0 > 0{
                        if cell.cartView.isHidden{
                            cell.plusImageView.isHidden = false
                            cell.customizableLabel.isHidden = false
                        }else{
                            cell.plusImageView.isHidden = true
                            cell.customizableLabel.isHidden = false
                        }
                    }else{
                        cell.plusImageView.isHidden = true
                        cell.customizableLabel.isHidden = true
                    }
                    cell.removeButton.tag = indexPath.row
                   // cell.addCartButton.setTitle(APPLocalize.localizestring.add.localize().uppercased(), for: .normal)
                    cell.addCart.setTitle(APPLocalize.localizestring.add.localize().uppercased(), for: .normal)
                    cell.addCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
                    cell.addCart.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
                    cell.removeButton.addTarget(self, action: #selector(removeFromCart), for: .touchUpInside)
                    
                }
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let index = indexPath.row-2
            if featuredProducts.count > 0 && featuredProducts.count > index {
                
                let productEntity = featuredProducts[index]
                let menuVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddOnsViewController) as! AddOnsViewController
                menuVC.isFromFeaturedProducts = true
                menuVC.featuredProducts = productEntity
                menuVC.delegate = self
              //  menuVC.cartList = productEntity.cart?[index]
                self.navigationController?.pushViewController(menuVC, animated: true)
                
            }
        } else {
            
            let index = indexPath.row-1
            let sectionValue = indexPath.section-featureSectionsList
            if categoriesArray.count > sectionValue, Int.val(val: categoriesArray[sectionValue].products?.count) > index {
                
                let productEntity = categoriesArray[sectionValue].products?[index]
                let menuVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddOnsViewController) as! AddOnsViewController
                menuVC.productDict = productEntity
                menuVC.isFromFeaturedProducts = false
                menuVC.delegate = self
               // menuVC.cartList = productEntity?.cart?[index]

                self.navigationController?.pushViewController(menuVC, animated: true)
            }
        }
    }
}


//MARK: - Add cart & Remove cart

extension ResturantMenuListViewController {
    
    @objc func moveToCartView (sender: UIButton) {
        
        let cartVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CartViewController) as! CartViewController
        cartVC.isFromResturantCart = true
        cartVC.delegate = self
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc func addToCart(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if User.main.id != nil {
                if indexPath.section == 0 {
                    
                    let cell = self.tableView.cellForRow(at: indexPath) as! AddCartWithImgView
                    let productEntity = featuredProducts[indexPath.row-2]
                    
                    if productEntity.id != nil {
                        self.productId = productEntity.id!
                    }
                    
                    if cartShopId != productEntity.shop_id && cartShopId != 0  {
                        restaurantFeatureProductAlert(productEntity: productEntity,rowIndex: indexPath.row,sectionIndex: indexPath.section)
                    }
                    else {
                        if (productEntity.cart?.count)! > 0 {
                            if productEntity.addons?.count == 0 {
                                if productEntity.cart?[0].id != nil, productEntity.cart?[0].quantity != nil {
                                    self.cartId = (productEntity.cart?[0].id)!
                                    self.quantity = (productEntity.cart?[0].quantity)! + 1
                                    cell.cartCountLbl.text = String(self.quantity)
                                    animate(cell.cartCountLbl)
                                }
                                self.restaurantCheckForCartItem()
                                
                            }else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreAddOnsViewController")as! MoreAddOnsViewController
                                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                vc.featureProduct = productEntity
                                vc.isFromFeatureProduct = true
                                vc.delegate = self
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                        } else {
                            if productEntity.addons?.count == 0 {
                                self.quantity = 1
                                self.restaurantCheckForCartItem()
                            }else{
                                let menuVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddOnsViewController) as! AddOnsViewController
                                menuVC.featuredProducts = productEntity
                                menuVC.isFromFeaturedProducts = true
                                menuVC.delegate = self
                                
                                self.navigationController?.pushViewController(menuVC, animated: true)
                            }
                        }
                    }
                }
                else {
                    let cell = self.tableView.cellForRow(at: indexPath) as! AddCartCell
                    
                    let index = indexPath.row-1
                    let sectionValue = indexPath.section-featureSectionsList
                    let productEntity = categoriesArray[sectionValue].products?[index]
                    
                    if productEntity?.id != nil {
                        self.productId = (productEntity?.id)!
                    }
                    
                    if cartShopId != productEntity?.shop_id && cartShopId != 0  {
                        restaurantProductAlert(productEntity: productEntity!,rowIndex: indexPath.row,sectionIndex: indexPath.section)
                    }
                    else {
                        
                        if (productEntity?.cart?.count)! > 0 {
                            if productEntity?.addons?.count == 0 {
                                
                                if productEntity?.cart?[0].id != nil, productEntity?.cart?[0].quantity != nil {
                                    self.cartId = (productEntity?.cart?[0].id)!
                                    self.quantity = (productEntity?.cart?[0].quantity)! + 1
                                    cell.cartCountLbl.text = String(self.quantity)
                                    animate(cell.cartCountLbl)
                                }
                                self.restaurantCheckForCartItem()
                            }else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreAddOnsViewController")as! MoreAddOnsViewController
                                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                vc.product = productEntity
                                vc.isFromFeatureProduct = false
                                vc.delegate = self
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                        } else {
                            if productEntity?.addons?.count == 0 {
                                
                                self.quantity = 1
                                self.restaurantCheckForCartItem()
                            }else{
                                let menuVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddOnsViewController) as! AddOnsViewController
                                menuVC.productDict = productEntity
                                menuVC.isFromFeaturedProducts = false
                                menuVC.delegate = self
                                self.navigationController?.pushViewController(menuVC, animated: true)
                            }
                        }
                    }
                }
            } else {
                let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
                self.navigationController?.pushViewController(signIn, animated: true)
            }
        }
    }
    
    func restaurantFeatureProductAlert(productEntity: Featured_products,rowIndex: Int,sectionIndex: Int){
        let cartAlert = UIAlertController(title: "", message: APPLocalize.localizestring.replaceCart.localize(), preferredStyle: .alert)
        
        cartAlert.addAction(UIAlertAction(title: APPLocalize.localizestring.yes.localize(), style: .default, handler: { (Void) in
            self.presenter?.get(api: .clearCart, data: nil)
//            self.clearCartIndexPath = IndexPath(row: rowIndex, section: sectionIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)  {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                
                let cell = self.tableView.cellForRow(at: indexPath) as! AddCartWithImgView
                
                if (productEntity.cart?.count)! > 0 {
                    
                    if productEntity.cart?[0].id != nil, productEntity.cart?[0].quantity != nil {
                        self.cartId = (productEntity.cart?[0].id)!
                        self.quantity = (productEntity.cart?[0].quantity)! + 1
                        cell.cartCountLbl.text = String(self.quantity)
                        animate(cell.cartCountLbl)
                    }
                } else {
                    
                    self.quantity = 1
                }
                
                self.restaurantCheckForCartItem()
              
            }
        }))
        
        cartAlert.addAction(UIAlertAction(title: APPLocalize.localizestring.no.localize(), style: .default, handler: nil))
        self.present(cartAlert, animated: true, completion: nil)
    }
    
    
    func restaurantProductAlert(productEntity: Products,rowIndex: Int,sectionIndex: Int){
        let cartAlert = UIAlertController(title: "", message: APPLocalize.localizestring.replaceCart.localize(), preferredStyle: .alert)
        
        cartAlert.addAction(UIAlertAction(title: APPLocalize.localizestring.yes.localize(), style: .default, handler: { (Void) in
            self.presenter?.get(api: .clearCart, data: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)  {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                let cell = self.tableView.cellForRow(at: indexPath) as! AddCartCell
                
                if (productEntity.cart?.count)! > 0 {
                    if productEntity.cart?[0].id != nil, productEntity.cart?[0].quantity != nil {
                        self.cartId = (productEntity.cart?[0].id)!
                        self.quantity = (productEntity.cart?[0].quantity)! + 1
                        cell.cartCountLbl.text = String(self.quantity)
                        animate(cell.cartCountLbl)
                    }
                } else {
                    
                    self.quantity = 1
                }
                
                self.restaurantCheckForCartItem()
            }
        }))
        
        cartAlert.addAction(UIAlertAction(title: APPLocalize.localizestring.no.localize(), style: .default, handler: nil))
        self.present(cartAlert, animated: true, completion: nil)
    }

    func restaurantCheckForCartItem() {
        
        self.addCart = AddCart()
        self.addCart?.quantity = self.quantity
        self.addCart?.cart_id = self.cartId
        self.addCart?.product_id = self.productId
        print(addCart!)
        loader.isHidden = false
        self.presenter?.post(api: .addCart, data: self.addCart?.toData())
    }
    
    func removeItem() {
        let alert = UIAlertController(title: NSLocalizedString("This item has multiple customizations added. Proceed to cart to remove item?", comment: ""), message: "", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default, handler: { action in
            //Handle your yes please button action here
            let cartVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CartViewController) as! CartViewController
            cartVC.isFromResturantCart = true
            cartVC.delegate = self
            self.navigationController?.pushViewController(cartVC, animated: true)
        })
        
        let noButton = UIAlertAction(title: "NO", style: .default, handler: { action in
            //Handle no, thanks button
            self.dismiss(animated: true)
        })
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        
        present(alert, animated: true)
    }
    
    @objc func removeFromCart(sender: UIButton) {
        
        
        let point = sender.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if User.main.id != nil {
                
                if indexPath.section == 0 {
                    let cell = self.tableView.cellForRow(at: indexPath) as! AddCartWithImgView

                    let productEntity = featuredProducts[sender.tag - 2]
                    
                    if (productEntity.cart?.count ?? 0) <= 1 {
                    if productEntity.id != nil {
                        self.productId = productEntity.id!
                    }
                    
                    if (productEntity.cart?.count)! > 0 {
                        
                        if productEntity.cart?[0].id != nil, productEntity.cart?[0].quantity != nil {
                            self.cartId = (productEntity.cart?[0].id)!
                            self.quantity = (productEntity.cart?[0].quantity)! - 1
                            cell.cartCountLbl.text = String(self.quantity)
                            animate(cell.cartCountLbl)
                        }
                    } else {
                        
                        print(productEntity.cart?.first?.id as Any)
                        self.quantity = 0
                    }
                    
                    self.addCart = AddCart()
                    self.addCart?.quantity = self.quantity
                    self.addCart?.product_id = self.productId
                    self.addCart?.cart_id = self.cartId
                    self.addCart?.addons_qty = []
                    self.addCart?.product_addons = []
                        print(addCart!)
                    loader.isHidden = false
                    self.presenter?.post(api: .addCart, data: self.addCart?.toData())
                        
                    }else{
                        removeItem()
                    }
                }
                else {
                    let cell = self.tableView.cellForRow(at: indexPath) as! AddCartCell

                    let index = indexPath.row-1
                    let sectionValue = indexPath.section-featureSectionsList
                    let productEntity = categoriesArray[sectionValue].products?[index]
                    if (productEntity?.cart?.count ?? 0) <= 1 {
                    if productEntity?.id != nil {
                        self.productId = (productEntity?.id)!
                    }
                    
                    if (productEntity?.cart?.count)! > 0 {
                        
                        if productEntity?.cart?[0].id != nil, productEntity?.cart?[0].quantity != nil {
                            self.cartId = (productEntity?.cart?[0].id)!
                            self.quantity = (productEntity?.cart?[0].quantity)! - 1
                            cell.cartCountLbl.text = String(self.quantity)
                            animate(cell.cartCountLbl)

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
                        print(addCart!)
                    loader.isHidden = false
                    self.presenter?.post(api: .addCart, data: self.addCart?.toData())
                     }else{
                        removeItem()
                    }
                }
            } else {
                let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
                self.navigationController?.pushViewController(signIn, animated: true)
            }
        }
    }
}

//MARK: Button Actions.
extension ResturantMenuListViewController {
    
    @objc func addShopToFavortiesList(sender: UIButton) {
        
        if User.main.id != nil {
            print(addFavorties.isSelected)
            if addFavorties.isSelected {
                doFavorites()
            }
            else{
                removeFavorites()
            }
        }
        else {
            let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
            self.navigationController?.pushViewController(signIn, animated: true)
        }
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - PostViewProtocol

extension ResturantMenuListViewController: PostViewProtocol {
    
    func cartList() {
        
      //  self.loader.isHidden = false
        self.presenter?.get(api: .addCart, data: nil)
    }
    
    //Error handling
    func onError(api: Base, message: String, statusCode code: Int) {
        cartItemView.isHidden = true
        self.loader.isHidden = true
        self.showToast(string: message)
    }
    
    //To hit the categorieslist
    func categoriesList() {
        
        if User.main.id != nil {
            
            self.catgories = CategoriesList()
            catgories?.shop = self.shop
            catgories?.user_id = User.main.id
            self.presenter?.get(api: .categoriesList, data: catgories?.toData())
            
        } else {
            
            self.catgories = CategoriesList()
            catgories?.shop = self.shop
            self.presenter?.get(api: .categoriesList, data: catgories?.toData())
            
        }
    }
    
    //To hit the do favorites
    func doFavorites() {
        
        guard shopList.id != nil else {
            return
        }
        self.doFav = DoFavourites()
        doFav?.shop_id = shopList.id
        self.presenter?.post(api: .doFavorite, data: doFav?.toData())
    }
    
    //To hit the remove favorites
    func removeFavorites() {
        
        guard shopList.id != nil else {
            return
        }
        
        self.presenter?.delete(api: .doFavorite, url: Base.doFavorite.rawValue + "/" + "\(shopList.id!)", data: nil)
    }
    
    //Callback for addCart
    func addCart(api: Base, data: CartList?) {
        
        if api == .clearCart {
            cartList()
        }
        
        if api == .addCart, data != nil {
            
            self.loader.isHidden = true
            var itemNumber = [Int]()
            var priceCount = [Double]()
            
                if (data?.carts?.count)! > 0 {
                    
                    cartCount = (data?.carts?.count)!
                    
                    for item in (data?.carts)! {
                        self.cartShopId = item.product?.shop?.id ?? 0
                        let productCount = item.quantity
                        
                        for item in item.cart_addons! {
                            itemNumber.append(Int(item.quantity!) * Int(productCount!))
                            let price = (item.addon_product?.price ?? 0.0) * Double(productCount ?? 0.0)
                            priceCount.append(price)
                        }
                        itemNumber.append(Int(item.quantity ?? 0.0))
                        let price = (item.product?.prices?.orignal_price ?? 0.0) * Double(item.quantity ?? 0.0)
                        priceCount.append(price)
                    }
                } else {
                    cartCount = 0
             }
            
            if cartCount > 0 {
                
                let totalItemAccount = itemNumber.reduce(0, +)
                let totalPriceAccount = priceCount.reduce(0, +)
                self.itemCountLbl.text = "\(totalItemAccount)" + APPLocalize.localizestring.totalItem.localize()  + String(format: "%.2f",totalPriceAccount)
                User.main.cartCount = totalItemAccount
             //   if cartItemView.isHidden {
              //     cartViewAnimShow(subView: self.cartItemView)
              //  }else{
                
                    cartItemView.isHidden = false
               // }
                
            } else {
              
              //  if !cartItemView.isHidden {
               //     cartViewAnimHide(subView: self.cartItemView)
               //
             //   }else{
                    cartItemView.isHidden = true
             //   }
                
            }
           
            loader.isHidden = true
            self.catgories = CategoriesList()
            catgories?.shop = self.shop
            catgories?.user_id = User.main.id
            self.loader.isHidden = false
            self.presenter?.get(api: .categoriesList, data: catgories?.toData())
        }
    }
    
    //Callback for favorites
    func doFavorite(api: Base, data: Message?) {
        
        if api == .doFavorite, data?.message != nil {
            
            if addFavorties.isSelected {
                addFavorties.setSelected(selected: true, animated: true)
            } else {
                addFavorties.setSelected(selected: false, animated: true)
            }
        }
    }
    
    //Callback for categorieslist
    func menuList(api: Base, data: ResturantMenuList?) {
        
        if api == .categoriesList, data != nil {
            
            self.loader.isHidden = true
            
            if (data?.featured_products)!.count > 0 {
                featuredProducts = (data?.featured_products)!
            }
            
            if (data?.categories?.count)! > 0 {
                categoriesArray = (data?.categories)!
            }
            
            numberofSection = featureSectionsList+Int.val(val: data?.categories?.count)
            tableView.reloadData()
        }
    }
}

//MARK: - Custom Delegate of AddCartUpdateDelegate

extension ResturantMenuListViewController: AddCartUpdateDelegate,MoreAddOnsViewControllerDelegate {
    func repeatProduct(product: Products, addOnsArr: NSMutableArray, qty: Int, cartId: Int) {
        if product.id != nil {
            self.productId = product.id!
        }
        
        if (product.cart?.count)! > 0 {
            
            if product.cart?[0].id != nil, product.cart?[0].quantity != nil {
                self.cartId = (product.cart?[0].id)!
                self.quantity = (product.cart?[0].quantity)! + 1
            }
            AddOnsFromCart(addOnsArray: addOnsArr)
        }else {
            
            self.quantity = 1
            AddOnsFromCart(addOnsArray: addOnsArr)
        }
    }
    
    func repeatFeatureProduct(featureProduct: Featured_products, addOnsArr: NSMutableArray) {
        if featureProduct.id != nil {
            self.productId = featureProduct.id!
        }
        
        if (featureProduct.cart?.count)! > 0 {
            
            if featureProduct.cart?[0].id != nil, featureProduct.cart?[0].quantity != nil {
                self.cartId = (featureProduct.cart?[0].id)!
                self.quantity = (featureProduct.cart?[0].quantity)! + 1
            }
            AddOnsFromCart(addOnsArray: addOnsArr)
        }else {
            self.quantity = 1
            AddOnsFromCart(addOnsArray: addOnsArr)
        }
    }
    
    func AddOnsFromCart(addOnsArray: NSMutableArray){
        
        self.addCart = AddCart()
        self.addCart?.quantity = self.quantity
        self.addCart?.cart_id = self.cartId
        self.addCart?.product_id = self.productId
        
        var productId = [Int]()
        var qtyArr = [Int]()
        for i in 0..<addOnsArray.count {
            
            let Result = addOnsArray[i] as! NSDictionary
            let addOnsID = Result.value(forKey: "id") as? Int ?? 0
            let quantity = Result.value(forKey: "qty") as? Int ?? 0
       //     quantity = quantity*self.quantity
            
            print("AddonsQuantity", quantity)
            print(addOnsID)
            
            qtyArr.append(quantity)
            productId.append(addOnsID)
        }
        self.addCart?.product_addons = productId
        self.addCart?.addons_qty = qtyArr
        
        print(addCart as Any)
        loader.isHidden = false
        self.presenter?.post(api: .addCart, data: self.addCart?.toData())
    }
    
    func chooseProductCartItemAction(product: Products) {
        let menuVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddOnsViewController) as! AddOnsViewController
        menuVC.isFromFeaturedProducts = false
        menuVC.productDict = product
        menuVC.delegate = self
        //  menuVC.cartList = productEntity.cart?[index]
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func chooseFeatureProductCartItemAction(featureProduct: Featured_products) {
        let menuVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddOnsViewController) as! AddOnsViewController
        menuVC.isFromFeaturedProducts = true
        menuVC.featuredProducts = featureProduct
        menuVC.delegate = self
        //  menuVC.cartList = productEntity.cart?[index]
        self.navigationController?.pushViewController(menuVC, animated: true)
    }

    func didReceiveAddCartUpdate(isRefreshPage: Bool?) {
        
        if isRefreshPage! {
            self.loader.isHidden = false
            categoriesList()
            cartList()
        }
    }
}

extension UIImage {
    
    func outline() -> UIImage? {
        
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.draw(in: rect, blendMode: .normal, alpha: 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0)
        context?.setLineWidth(5.0)
        context?.stroke(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}
