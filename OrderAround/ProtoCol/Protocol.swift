//
//  Protocol.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

//MARK:- Web Service Protocol

protocol PostWebServiceProtocol : class {
    
    var interactor : PostInteractorOutputProtocol? {get set}
    
    var completion : ((CustomError?, Data?)->())? {get set}
    
    func retrieve(api : Base, url : String?, data : Data?, imageData: [String : Data]?, type : HttpType, completion : ((CustomError?, Data?)->())?)
    
}


//MARK:- Interator Input

protocol PostInteractorInputProtocol : class {
    
    var webService : PostWebServiceProtocol? {get set}
    
    func send(api : Base, data : Data?, type : HttpType)
    
    func send(api : Base, imageData : [String : Data]?, data : Data?)
    
    func send(api : Base, url : String, data : Data?, type : HttpType)
    
}


//MARK:- Interator Output

protocol PostInteractorOutputProtocol : class {
    
    var presenter : PostPresenterOutputProtocol? {get set}
    
    func on(api : Base, response : Data)
    
    func on(api : Base, error : CustomError)
    
}


//MARK:- Presenter Input

protocol PostPresenterInputProtocol : class {
    
    var interactor : PostInteractorInputProtocol? {get set}
    
    var controller : PostViewProtocol? {get set}
    /**
     Send POST Request
     @param api Api type to be called
     @param data HTTP Body
     */
    func post(api : Base, data : Data?)
    /**
     Send GET Request
     @param api Api type to be called
     @param parameters paramters to be send in request
     */
    
    func get(api : Base, data : Data?)
    
    /**
     Send GET Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     */
    
    func get(api : Base, url : String)
    
    /**
     Send POST Request
     @param api Api type to be called
     @param imageData : Image to be sent in multipart
     @param parameters : params to be sent in multipart
     */
    func post(api : Base, imageData : [String : Data]?, data : Data?)
    
    /**
     Send put Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func put(api : Base, url : String, data : Data?)
    
    /**
     Send delete Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func delete(api : Base, url : String, data : Data?)
    
    /**
     Send patch Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func patch(api : Base, url : String, data : Data?)
    
    /**
     Send Post Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func post(api : Base, url : String, data : Data?)
    
    
}


//MARK:- Presenter Output

protocol PostPresenterOutputProtocol : class {
    
    func onError(api : Base, error : CustomError)
    func sendOtp(api : Base, data : Data)
    func signUpAuth(api: Base, response: Data)
    func sendOath(api : Base , data : Data)
    func forgetPassword(api : Base , data : Data)
    func sendUserProfile(api : Base, data: Data)
    func sendShopListReq(api: Base, data: Data)
    func sendCategoriesListReq(api: Base, data: Data)
    func sendDoFavorite(api: Base, data: Data)
    func sendAddCart(api: Base, data: Data)
    func sendSearchList(api: Base, data: Data)
    func sendUserAddress(api: Base, data: Data, msg: Data)
    func sendUserCartDetail(api: Base, data: Data, msg: Data)
    func sendCuisines(api: Base, data: Data, msg: Data)
    func sendGetPromocode(api: Base, data: Data)
    func sendApplyPromoCode(api: Base, data: Data)
    func sendChangePassword(api: Base, data: Data)
    func sendOnGoingOrder(api: Base, data: Data)
    func sendReorder(api: Base, data: Data)
    func sendOrders(api: Base, data: Data)
    func sendRatings(api: Base, data: Data)
    func sendDisputeList(api: Base, data: Data)
    func sendCreateDispute(api: Base, data: Data)
    func sendWalletHistory(api: Base, data: Data)
    func sendAddAmount(api: Base, data: Data)
    func sendSettingsData(api: Base, data: Data)
  //  func sendVersionData(api: Base, data: Data)

}


//MARK: - View

protocol PostViewProtocol : class {
    
    var presenter : PostPresenterInputProtocol? {get set}
    
    func onError(api : Base, message : String, statusCode code : Int)
    func getOtp(api : Base, otp : OTP?)
    func signUp(api: Base, response: UserProfile?)
    func getOath(api : Base , data : LoginRequestData?)
    func getOTPForForgetPassword(api: Base, data: ForgotPasswordEntity?)
    func getUserProfile(api: Base, data: UserProfileDetails?)
    func shopList(api: Base, data: Json4Swift_Base?)
    func menuList(api: Base, data: ResturantMenuList?)
    func doFavorite(api: Base, data: Message?)
    func getFavoriteList(api: Base, data: FavouriteList?)
    func addCart(api: Base, data: Data?)
    func searchProduct(api: Base, data: SearchProducts?)
    func addCart(api: Base, data: CartList?)
    func getAddress(api: Base, data: [UserAddressDetails]?, msg: Message?)
    func getCardDetails(api: Base, data: [Card]?, msg: Message?)
    func getCuisinesList(api: Base, data: [Cuisines]?) //, msg: Message?
    func getPromoCode(api: Base, data: [PromoCodeEntity]?)
    func getApplyPromocode(api: Base, data: CartList?)
    func getChangePassword(api: Base, data: Message?)
    func getOnGoingOrder(api: Base, data: [OrderList]?)
    func getOrders(api: Base, data: OrderList?)
    func getReorder(api: Base, data: Carts?)
    func getDisputeList(api: Base, data: [Dispute]?)
    func getRatings(api: Base, data: Message)
    func getWalletHistory(api: Base, data: [WalletModel]?)
    func getAddAmount(api: Base, data: AddAmountEntity?)
    func getSettingsData(api: Base, data: SettingsEntity?)
//    func getVersionData(api: Base, data: VersionEntity?)

    
}

//MARK: - View

extension PostViewProtocol {
    
    var presenter: PostPresenterInputProtocol? {
        
        get {
            presenterObject?.controller = self
            self.presenter = presenterObject
            return presenterObject
        }
        set(newValue){
            
            presenterObject = newValue
        }
    }
    
    func getOtp(api : Base, otp : OTP?) {return}
    func signUp(api: Base, response: UserProfile?) {return}
    func getOath(api : Base , data : LoginRequestData?) {return}
    func getOTPForForgetPassword(api: Base, data: ForgotPasswordEntity?) {return}
    func getUserProfile(api: Base, data: UserProfileDetails?) {return}
    func shopList(api: Base, data: Json4Swift_Base?) {return}
    func menuList(api: Base, data: ResturantMenuList?) {return}
    func doFavorite(api: Base, data: Message?) {return}
    func getFavoriteList(api: Base, data: FavouriteList?) {return}
    func addCart(api: Base, data: Data?) {return}
    func searchProduct(api: Base, data: SearchProducts?) {return}
    func addCart(api: Base, data: CartList?) {return}
    func getAddress(api: Base, data:  [UserAddressDetails]?, msg: Message?) {return}
    func getCardDetails(api: Base, data: [Card]?, msg: Message?) {return}
    func getCuisinesList(api: Base, data: [Cuisines]?) {return} //, msg: Message?
    func getPromoCode(api: Base, data: [PromoCodeEntity]?) {return}
    func getApplyPromocode(api: Base, data: CartList?) {return}
    func getChangePassword(api: Base, data: Message?) { return }
    func getOnGoingOrder(api: Base, data: [OrderList]?) { return }
    func getOrders(api: Base, data: OrderList?) { return }
    func getReorder(api: Base, data: Carts?) { return }
    func getDisputeList(api: Base, data: [Dispute]?) { return }
    func getRatings(api: Base, data: Message) { return }
    func getWalletHistory(api: Base, data: [WalletModel]?) {return}
    func getAddAmount(api: Base, data: AddAmountEntity?) {return}
    func getSettingsData(api: Base, data: SettingsEntity?) {return}
  //  func getVersionData(api: Base, data: VersionEntity?) {return}

}



// MARK:- View Structure
protocol UIViewStructure {
    //Responsible for initialization of all variables and data to be initiated only once
    func initalLoads()
    
    // All View Localization to be completely implemented here
    func localize()
    
    // Font Design Color and font handling to here implemented here
    func design()
    
    // All Constraint and size handling to be written here
    func layouts()
}

// MARK: - Protocol
protocol FeedBackPopViewViewControllerDelegate: class {
    func FeedBackNextScreen()
}


