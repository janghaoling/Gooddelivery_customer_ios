//
//  Constants.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit

typealias ViewController = (UIViewController & PostViewProtocol)
var presenterObject : PostPresenterInputProtocol?

let appDelegate = UIApplication.shared.delegate as! AppDelegate
var withSchedule = false

// MARK:- Login Type

enum LoginType : String, Codable {
    
    case google
    case manual
    case facebook
    
}

//MARK:- Constant Strings

struct Constants {
    
    static let string = Constants()

    let empty = ""
    let noDevice = "no device"
    let English = "English"
    let Arabic = "Arabic"
    let Spanish = "Spanish"
    let Japanese = "Japanese"
    let uploadFileName = "avatar"
    let addZero = ".00"
    var countryCode = "CL"
    
}

struct APPLocalize {
    
    static let localizestring = APPLocalize()
    
    
    let reorder = "localize.reorder"
    
    let next = "localize.next"
    let selectSource = "localize.selectSource"
    let camera = "localize.camera"
    let photoLibrary = "localize.photoLibrary"
    let cannotMakeCallAtThisMoment = "localize.cannotMakeCallAtThisMoment"
    let couldnotOpenEmailAttheMoment = "localize.couldnotOpenEmailAttheMoment"
    let areYouSureWantToLogout = "localize.areYouSureWantToLogout"
    
    
    let ShowRestaurantsWith = "localize.ShowRestaurantsWith"
    let Cuisines = "localize.Cuisines"
    let PureVeg = "Pure veg"
    let Offer = "Offer"
    let letsImpress = "localize.letsImpress"
    let totalResturant = "localize.totalResturant"
    let relevent = "localize.relevent"
    let empty = ""
    let currentlyAvailble = "localize.currentlyAvailble"
    let currentlyUnAvailable = "localize.currentlyUnAvailable"
    var countryCode = "CL"
    var countryPickerTitle = "localize.countryPickerTitle"
    var countryNumber = "+56"
    let Done = "localize.Done"
    let Back = "localize.Back"
    let History = "localize.History"
    let registration = "localize.registration"
    let noDevice = "localize.noDevice"
    let loginSuccess = "localize.loginSuccess"
    let manual = "localize.manual"
    let OK = "localize.OK"
    let delet = "localize.delete"
    let Cancel = "localize.Cancel"
    let no =  "localize.no"
    let yes = "localize.yes"
    let NA = "localize.NA"
    
    let flat =  "localize.flat"
    let offOrder = "localize.offOrder"
    let Rating = "localize.Rating"
    let noRating = "localize.noRating"
    let mins = "localize.mins"
    
    //userAccount
    let edit = "localize.edit"
    let myAccount = "localize.myAccount"
    let menuDetails = "localize.menuDetails"
    let manageAdress = "localize.manageAdress"
    let favorites = "localize.favorites"
    let payment = "localize.payment"
    let myOrder = "localize.myOrder"
    let promoDetails = "localize.promoDetails"
    let changePassword = "localize.changePassword"
    let changeLanguage = "localize.changeLanguage"
    let logout = "localize.logout"
    let appVersion = "localize.appVersion"
    
    
    //Filter
    let filter = "localize.filter"
  
    
    //home view
    let locating = "localize.locating"
    let filters = "localize.filters"
    
    // changeLanguage
    let English = "localize.English"
    let Arabic = "localize.Arabic"
    let Spanish = "localize.Spanish"
    let Japanese = "localize.Japanese"
    
    //changePassword
    let newPassword = "localize.newPassword"
    let confirmPassword = "localize.confirmPassword"
    let oldPassword = "localize.oldPassword"
    let change = "localize.change"
    let passwordChanged = "localize.passwordChanged"
    
    
    //PromocodeView
    let promoCode = "localize.promoCode"
    let expireOn = "localize.expireOn"
    let promoApplied = "localize.promoApplied"
    let noPromoTitle = "localize.noPromoTitle"
    let noPromoContent = "localize.noPromoContent"
    let apply = "localize.apply"
    let applied = "localize.applied"
    
    //MyOrder
    let orderEmptyHead = "localize.orderEmptyHead"
    let orderEmptyContent = "localize.orderEmptyContent"
    let currentOrders = "localize.currentOrders"
    let pastOrders = "localize.pastOrders"
    let anotherRestaurant = "localize.anotherRestaurant"
    let anotherDishesSameRestaurant = "localize.anotherDishesSameRestaurant"
    let orderCancel = "localize.orderCancel"
    let delivered = "localize.delivered"
    let order = "localize.order"
    //payment
    let wallet = "localize.wallet"
    let delete = "localize.delete"
    let card = "localize.card"
    let addCard = "localize.addCard"
    let payOnDelivery = "localize.payOnDelivery"
    let cash = "localize.cash"
    //wallet
    let walletAmount = "localize.walletAmount"
    let add = "localize.add"
    //AddAmount
    let addAmount = "localize.addAmount"
    let enterAmount = "localize.enterAmount"
    let pay = "localize.pay"
    let paymentOption = "localize.paymentOption"
    //Add Card
    let addNewCard = "localize.addNewCard"
    let cardNumber = "localize.cardNumber"
    let vaildThiru = "localize.vaildThiru"
    let cvv = "localize.cvv"
    //managedAddr
    let savedAddress = "localize.savedAddress"
    let addNewAddress = "localize.addNewAddress"
    let addAddressToProceed = "localize.addAddressToProceed"
    let editAddressConfirmation = "localize.editAddressConfirmation"
    let home = "localize.home"
    let work = "localize.work"
    let others = "localize.others"
    
    //search
    let resturant = "localize.resturant"
    let dishes = "localize.dishes"
    let searchForResturant = "localize.searchForResturant"
    
    //cartpage
    let goodFoodIsAlwaysGettingCooked = "localize.goodFoodIsAlwaysGettingCooked"
    let pleaseOrderDish = "localize.pleaseOrderDish"
    let pleaseLoginAndOrder = "localize.pleaseLoginAndOrder"
    
    //Restaurant
    let deliveryTime = "localize.deliveryTime"
    let featuredProducts = "localize.featuredProducts"
    let totalItem = "localize.totalItem"
    let viewCart = "localize.viewCart"
    let replaceCart = "localize.replaceCart"
    
    //editAccount
    let editAccount = "localize.editAccount"
    let userName = "localize.userName"
    let update = "localize.update"
    let MobileNumber = "localize.MobileNumber"
    let emailAddress = "localize.emailAddress"
    let profileUpdated = "localize.profileUpdated"
    
    //
    let knockText = "localize.knockText"
    let knockDescription = "localize.knockDescription"
    
    //Favourite
    let favEmptyHeading = "localize.favEmptyHeading"
    let favEmptyContent = "localize.favEmptyContent"
    let shopUnAvilable = "localize.shopUnAvilable"
    
    //Help
    let complained = "localize.complained"
    let canceled = "localize.canceled"
    let refund = "localize.refund"
    let cancelOrder = "localize.cancelOrder"
    let enterDesc = "localize.enterDesc"
    let submit = "localize.submit"
    
    
    
    //order track
    let orderPlaced = "localize.orderPlaced"
    let orderConfirmed = "localize.orderConfirmed"
    let orderProcessed = "localize.orderProcessed"
    let orderPickedUp = "localize.orderPickedUp"
    let orderDelivered = "localize.orderDelivered"
    
    let orderPlacedDescription = "localize.orderPlacedDescription"
    let orderConfirmedDescription = "localize.orderConfirmedDescription"
    let orderProcessedDescription = "localize.orderProcessedDescription"
    let orderPickedUpDescription = "localize.orderPickedUpDescription"
    let orderDeliveryDescription = "localize.orderDeliveryDescription"
    
    
  
    let shopClosed = "localize.shopClosed"
    let closed = "localize.closed"
    let addFavMsg = "localize.addFavMsg"
    let customNotes = "localize.customNotes"
    let addItem = "localize.addItem"
    let relatedTo = "localize.relatedTo"
    let perItem = "localize.perItem"
    let item = "localize.item"
    let from = "localize.from"
    
    let deleteAddress = "Are you sure want to delete this address?"
    let OTP = "localize.OTP"
    let details = "localize.details"
    let help = "localize.help"
    let cartTotalItem = "localize.cartTotalItem"
    let deliveryFee = "localize.deliveryFee"
    let deliveryCharge = "localize.deliveryCharge"
    let seriveTax = "localize.seriveTax"
    let discount = "localize.discount"
    let walletDeduction = "localize.walletDeduction"
  
    
    let reset = "localize.reset"
    let applyFilter = "localize.applyFilter"
    
    //Home controller
    let noRestaurant = "localize.noRestaurant"
    let noRestaurantContent = "localize.noRestaurantContent"
    
    let dispute = "localize.dispute"
    let chatUs = "localize.chatUs"
    let helpDescription = "localize.helpDescription"
    let enter = "localize.enter"
    
    let setDeliveryLocation = "localize.setDeliveryLocation"
    let address = "localize.address"
    let saveAs = "localize.saveAs"

    let saveAndProceed = "localize.saveAndProceed"
    let houseNo = "localize.houseNo"
    let landMark = "localize.landMark"
    let itemDelayForResturant = "localize.itemDelayForResturant"
    let itemDelayForPacking = "localize.itemDelayForPacking"
    let itemUpdationLate = "localize.itemUpdationLate"
    let other = "localize.other"
    let someTest = "localize.someTest"
    let sorryForCancel = "localize.sorryForCancel"
    let productNotAvailable = "localize.productNotAvailable"
    
   
    let skip = "localize.skip"
    let signIn = "localize.signIn"
    let signUp = "localize.signUp"
    let fresh = "localize.fresh"
    let discoverNewDish = "localize.discoverNewDish"
    let holdFavRest = "localize.holdFavRest"
    let search = "localize.search"
    let viewMenus = "localize.viewMenus"
    let restaurantsAroundYou = "localize.restaurantsAroundYou"
    let bookMark = "localize.bookMark"
    let addPlcaeWantToVisit = "localize.addPlcaeWantToVisit"
    let futureBookMark = "localize.futureBookMark"
    let mobileNumber = "localize.mobileNumber"
    let password = "localize.password"
    let dontHaveAccount = "localize.dontHaveAccount"
    let forgetPassword = "localize.forgetPassword"
    let copnnectWithSocial = "localize.copnnectWithSocial"
    let alreadyHaveAccount = "localize.alreadyHaveAccount"
    let signInHere = "localize.signInHere"
    let name = "localize.name"
    
    let terrible = "localize.terrible"
    let bad = "localize.bad"
    let good = "localize.good"
    let okay = "localize.okay"
    let superb = "localize.superb"
    let feedback = "localize.feedback"
    let howWasTheDelivery = "localize.howWasTheDelivery"
    let giveSomeFeedbackinWords  = "localize.giveSomeFeedbackinWords"
    
    let addAddress = "localize.addAddress"
    let changeAddress = "localize.changeAddress"
    let selectAddress = "localize.selectAddress"
    let continues = "localize.continues"
    let account = "localize.account"
    let loginPrSignUp = "localize.loginPrSignUp"
    let login = "localize.login"
    
  
    let confirm = "localize.confirm"
    let manageAccount = "localize.manageAccount"
    let writeSomething = "localize.writeSomething"
    
    let register = "localize.register"
    let didNotGetOTP = "localize.didNotGetOTP"
    let resentOTP = "localize.resentOTP"
    let verficationCode = "localize.verficationCode"
    
    let verficationSentText = "localize.verficationSentText"
    let enterCorrectOTP = "localize.enterCorrectOTP"
    
    let continueText = "localize.continueText"
    let enterMobileNumber = "localize.enterMobileNumber"
    let enterOtp = "localize.enterOtp"
   
    

    
}

// MARK: - Common error messages

public struct ERROR_MESSAGE {
    
    static let noInternet = "No internet connection available, please check your internet connection."
    static let enterEmailId = "Please enter your email id."
    static let enterValidEmailId = "Please enter valid email id."
    static let enterValidPhone = "Please enter valid phone number."
    static let enterPassword = "Please enter your password."
    static let removeSpaceInPassword = "Please enter password without spaces."
    static let fbDeniedEmailAccess = "Sorry, you do not have email id in your facebook account. Please try with different account, that has email id."
    static let fbGeneralError = "Sorry, Couldn't able to fetch details from your facebook account. Please try again."
    static let fbNoToken = "Sorry, couldn't able to get access token from facebook. please try again."
    static let fbPermissionDenied = "Permission denied for facebook access"
    static let fbNoEmail = "Sorry, you do not have email id in your facebook account. Please try with different account, that has email id."
    
}



//Defaults Keys

struct Keys {
    
    static let list = Keys()
    let userData = "userData"    
    let id = "id"
    let name = "name"
    let accessToken = "access_token"
    let latitude = "latitude"
    let lontitude = "lontitude"
    let coOrdinates = "coOrdinates"
    let firstName = "firstName"
    let lastName = "lastName"
    let picture = "picture"
    let email = "email"
    let mobile = "mobile"
    let socialLoginAccessToken = "socialLoginAccessToken"
    let continueText = "Continue"
    let enterMobileNumber = "Enter Mobile Number"
    let verficationCode = "Verification Code"
    let verficationSentText = "Please enter the verification code sent to your"
    let refreshToken = "refresh_token"
    let cart = "cart"
    let cartCount = "cartCount"
    let filterDetails = "filter"
    let login_by = "login_by"
    let payment_mode = "payment_mode"
    let wallet_balance = "wallet_balance"
    let language = "Language"
    
}



// Date Formats

struct DateFormat {
    
    static let list = DateFormat()
    let yyyy_mm_dd_HH_MM_ss = "yyyy-MM-dd HH:mm:ss"
    let MMM_dd_yyyy_hh_mm_ss_a = "MMM dd, yyyy hh:mm:ss a"
    let hhmmddMMMyyyy = "hh:mm a - dd:MMM:yyyy"
    let ddMMyyyyhhmma = "dd-MM-yyyy hh:mma"
    let ddMMMyyyy = "dd MMM yyyy"
    let hh_mm_a = "hh : mm a"
    let dd_MM_yyyy = "dd-MM-yyyy"
    let WalletHistoryFormat = "EE,MMM d,h:mm a"
}


// Devices

enum DeviceType : String, Codable {
    
    case ios = "ios"
    case android = "android"
    
}

// Order Status

enum OrderStatus : String, CaseIterable {
    
    case ORDERED = "ORDERED"
    case RECEIVED = "RECEIVED"
    case PROCESSING = "PROCESSING"
    case REACHED = "REACHED"
    case ASSIGNED = "ASSIGNED"
    case PICKEDUP = "PICKEDUP"
    case ARRIVED = "ARRIVED"
    case COMPLETED = "COMPLETED"
    case CANCEL = "CANCELLED"
    case None = "NONE"
    
}

enum EmptyImage : String,Codable {
    case promoCodeEmpty = "ic_promo_empty"
    case favEmpty = "ic_empty_fav"
    case cartEmpty = "ic_cart_empty"
    case orderEmpty = "ic_order_empty"
    case restaurantEmpty = "restaurant_placeholder"
}

// Dispute

enum DisputeStatus : String, Codable {
    
    case CREATED
    case RESOLVE
    case NODISPUTE
    
}

enum DisputeString : String, Codable {
    
    case CREATED = "DISPUTE CREATED"
    case RESOLVE = "DISPUTE RESOLVED"
    
}


enum UserType : String, Codable {
    
    case user = "user"
    case transporter = "transporter"
    
}

//enum Language : String {
//
//    case english = "en"
//    case spanish = "es"
//
//}



enum defaultSystemSound : Float {
    case peek = 1519
    case pop = 1520
    case cancelled = 1521
    case tryAgain = 1102
    case Failed = 1107
}


extension UIImageView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi)
        rotateAnimation.duration = duration
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

func animate(_ label: UILabel?) {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
        // moves label up 100 units in the y axis
        label?.transform = CGAffineTransform(translationX: 0, y: -30)
    }) { finished in
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            // move label back down to its original position
            label?.transform = CGAffineTransform(translationX: 0, y: 5)
        }) { finished in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                // move label back down to its original position
                label?.transform = CGAffineTransform(translationX: 0, y: -2)
            }) { finished in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    // move label back down to its original position
                    label?.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        }
    }
}


func cartViewAnimShow(subView: UIView){
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                   animations: {
                    subView.frame.origin.y -= subView.bounds.height
                    subView.layoutIfNeeded()
    }, completion: nil)
    subView.isHidden = false
}
func cartViewAnimHide(subView: UIView){
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                   animations: {
                    subView.center.y += subView.bounds.height
                    subView.layoutIfNeeded()
                    
    },  completion: {(_ completed: Bool) -> Void in
        subView.isHidden = true
    })
}

func animation(fromLeft view: UIView?) {
    
    let cellContentView: UIView? = view
    let rotationAngleDegrees: CGFloat = -30
    let rotationAngleRadians: CGFloat = rotationAngleDegrees * (.pi / 180)
    let offsetPositioning = CGPoint(x: 500, y: -20.0)
    var transform: CATransform3D = CATransform3DIdentity
    transform = CATransform3DRotate(transform, rotationAngleRadians, -50.0, 0.0, 1.0)
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, -50.0)
    cellContentView?.layer.transform = transform
    cellContentView?.layer.opacity = 0.8
    
    UIView.animate(withDuration: 0.65, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.8, options: [], animations: {
        cellContentView?.layer.transform = CATransform3DIdentity
        cellContentView?.layer.opacity = 1
    }) { finished in
    }
}


extension UIViewController {
    // MARK: - Hide KeyBoard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
