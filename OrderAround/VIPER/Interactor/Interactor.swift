//
//  Interactor.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

class Interactor  {
    
    var webService: PostWebServiceProtocol?
    
    var presenter: PostPresenterOutputProtocol?
    
}

//MARK:- PostInteractorInputProtocol

extension Interactor : PostInteractorInputProtocol {
    
    func send(api: Base, imageData: [String : Data]?, data: Data?) {
        webService?.retrieve(api: api,url: nil, data: data, imageData: imageData, type: .POST, completion: nil)
    }
    func send(api: Base, url: String, data: Data?, type: HttpType) {
        webService?.retrieve(api: api,url: url, data: data, imageData: nil, type: type, completion: nil)
    }
    func send(api: Base, data: Data?, type: HttpType) {
        webService?.retrieve(api: api, url: nil, data: data, imageData: nil, type: type, completion: nil)
    }
    
}


extension Interactor : PostInteractorOutputProtocol {

    func on(api: Base, response: Data) {
        
        switch api {
        case .getOTP, .verifyOTP, .resetPassword:
            
            self.presenter?.sendOtp(api: api, data: response)
       
        case .signUp:
           
            self.presenter?.signUpAuth(api: api, response: response)
           
        case .login, .socialLogin:
            
            self.presenter?.sendOath(api: api, data: response)
            
        case .forgetPassword:
            
            self.presenter?.forgetPassword(api: api, data: response)
       
        case  .userProfile:
            
            self.presenter?.sendUserProfile(api : api, data: response)
            
        case .shopList:
            self.presenter?.sendShopListReq(api: api, data: response)
        
        case .categoriesList:
            self.presenter?.sendCategoriesListReq(api: api, data: response)
            
        case .doFavorite,.getFavourite:
            self.presenter?.sendDoFavorite(api: api, data: response)
            
        case .addCart, .clearCart:
            self.presenter?.sendAddCart(api: api, data: response)
        case .searchProduct :
            self.presenter?.sendSearchList(api: api, data: response)
         
        case .userAddress:
            self.presenter?.sendUserAddress(api: api, data: response, msg: response)
            
        case .cardDetail:
            self.presenter?.sendUserCartDetail(api: api, data: response, msg: response)
        
        case .cuisines:
            self.presenter?.sendCuisines(api: api, data: response, msg: response)
            
        case .getPromocode :
            self.presenter?.sendGetPromocode(api: api, data: response)
            
        case .applyPromocode :
            self.presenter?.sendApplyPromoCode(api: api, data: response)
            
        case .changePassword :
            self.presenter?.sendChangePassword(api: api, data: response)
            
        case .onGoingOrders, .pastOrders :
            self.presenter?.sendOnGoingOrder(api: api, data: response)
            
        case .order,.createDispute :
            self.presenter?.sendOrders(api: api, data: response)
            
        case .reOrder :
            self.presenter?.sendReorder(api: api, data: response)
            
        case .disputeHelp:
            self.presenter?.sendDisputeList(api: api, data: response)
        case .ratings:
            self.presenter?.sendRatings(api: api, data: response)
        case .walletHistory:
            self.presenter?.sendWalletHistory(api: api, data: response)
        case .addAmount:
            self.presenter?.sendAddAmount(api: api, data: response)
        case .settings :
            self.presenter?.sendSettingsData(api: api, data: response)
            
        default:
            break
        
            
        }
    }
    
    func on(api: Base, error: CustomError) {
        
        presenter?.onError(api: api, error: error)
        
    }
    
    
}

