//
//  CommonOutputEntityList.swift
//  Project
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation


struct OTP: JSONSerializable {
    
    var message: String?
    var otp: Int?
    
}

struct UserProfile: JSONSerializable {
    
    var email: String?
    var id: Int?
    var login_by: LoginType?
    var name: String?
    var phone: String?
    var social_unique_id: String?
    var password: String?
    var password_confirmation: String?
    var accessToken: String?
    
}

struct ForgotPasswordEntity : JSONSerializable {
    var message : String?
    var user : UserDataResponse?
    
}

struct UserProfileDetails: JSONSerializable {
    
    var email: String?
    var id: Int?
    var login_by: String?
    var name: String?
    var phone: String?
    var social_unique_id: String?
    var avatar: String?
    var device_token: String?
    var device_id: String?
    var device_type: String?
    var stripe_cust_id: String?
    var wallet_balance: Int?
    var otp: String?
    var currency: String?
    var payment_mode: [String]?
    var addresses: [UserAddressDetails]?
   
    var cart: [Items]?

}

struct Message: JSONSerializable {
    var message : String?
}

