//
//  PresenterProcessor.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class PresenterProcessor {
    
    
    static let shared = PresenterProcessor()

    func  searchProduct(data: Data) -> SearchProducts? {
        return data.getDecodedObject(from: SearchProducts.self)!
    }
    
    func success(api : Base, response : Data)->String{
        return .Empty
        
    }
    
    func getOTP(data: Data)-> OTP? {
        
        return data.getDecodedObject(from: OTP.self)
        
     }
    
    func SignUp(data: Data)-> UserProfile? {
        
        return data.getDecodedObject(from: UserProfile.self)
    }
    
    
    
    func loginRequest(data : Data)->LoginRequestData? {
        return data.getDecodedObject(from: LoginRequestData.self)
    }
    
    func forgetPassword(data : Data)-> ForgotPasswordEntity? {
         return data.getDecodedObject(from: ForgotPasswordEntity.self)
    }
    
    func userProfileData(data : Data)-> UserProfileDetails? {
        return data.getDecodedObject(from: UserProfileDetails.self)
    }
    
    func shopList(data : Data)-> Json4Swift_Base? {
        return data.getDecodedObject(from: Json4Swift_Base.self)
    }
    
    func resturantList(data : Data)-> ResturantMenuList? {
        print("***********",data.getDecodedObject(from: ResturantMenuList.self))
        return data.getDecodedObject(from: ResturantMenuList.self)
    }
    
    func message(data : Data)-> Message? {
        return data.getDecodedObject(from: Message.self)
    }
    
    func addCartItem(data : Data)-> CartList? {
        return data.getDecodedObject(from: CartList.self)
    }
    
    func userAddressDetails(data: Data)-> [UserAddressDetails]? {
        
        return data.getDecodedObject(from: [UserAddressDetails].self)
    }
    
    func userCartDetail(data: Data)-> [Card]? {
        
        return data.getDecodedObject(from: [Card].self)
    }
    func cuisines(data: Data)-> [Cuisines]? {
        
        return data.getDecodedObject(from: [Cuisines].self)
    }
    
    func getPromoCode(data: Data)-> [PromoCodeEntity]? {
        
        return data.getDecodedObject(from: [PromoCodeEntity].self)
    }
    
    func applyPromocode(data: Data)-> CartList? {
        
        return data.getDecodedObject(from: CartList.self)
    }
    
    func changePassword(data: Data)-> Message? {
        
        return data.getDecodedObject(from: Message.self)
    }
    
    func favoriteList(data: Data)-> FavouriteList? {
        
        return data.getDecodedObject(from: FavouriteList.self)
    }
    
    func onGoingOrders(data: Data)-> [OrderList]? {
        
        return data.getDecodedObject(from: [OrderList].self)
    }
    
    func reOrder(data: Data)-> Carts? {
        
        return data.getDecodedObject(from: Carts.self)
    }
    
    func getOrders(data: Data)-> OrderList? {
        
        return data.getDecodedObject(from: OrderList.self)
    }
    
    func disputeHelp(data: Data)-> [Dispute]? {
        
        return data.getDecodedObject(from: [Dispute].self)
    }
    func getWalletHistory(data: Data)-> [WalletModel]? {
        
        return data.getDecodedObject(from: [WalletModel].self)
    }
    
    func getAddAmount(data: Data)-> AddAmountEntity? {
        
        return data.getDecodedObject(from: AddAmountEntity.self)
    }
    func getSettingsData(data: Data)-> SettingsEntity? {
        
        return data.getDecodedObject(from: SettingsEntity.self)
    }
    
//    func signUpAuth(data: Data)-> SignUpMdel?{
//        
//        
//        return data.getDecodedObject(from: SignUpMdel.self)
//    }
//
//    func login(data: Data)-> loginModel? {
//        
//        return data.getDecodedObject(from: loginModel.self)!
//    }
//    
//    
//    func resetPassword(data: Data)-> resetPasswordModel? {
//        
//        return data.getDecodedObject(from: resetPasswordModel.self)!
//    }
//    
//    
//    func updateLocation(data: Data)-> updateLocationModel{
//        
//        return data.getDecodedObject(from: updateLocationModel.self)!
//    }
//    
//    func  OnlineStatus(data: Data)-> OnlinestatusModelResponse {
//        
//        return data.getDecodedObject(from: OnlinestatusModelResponse.self)!
//    }
    
}






