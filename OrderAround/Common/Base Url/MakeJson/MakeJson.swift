//
//  MakeJson.swift
//  User
//
//  Created by CSS on 11/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class MakeJson {
    
    // MARK:- SignUp
    
    class func signUp(loginBy : LoginType, email : String?, password : String?, socialId : String? = nil, userName : String,phone: Int?)->UserData {
        
        let userDataObject = UserData()
        //userDataObject.device_id = UUID().uuidString
        //userDataObject.device_token = deviceTokenString
       //userDataObject.device_type = .ios
        userDataObject.email = email
        userDataObject.name = userName
       // userDataObject.login_by = loginBy
        userDataObject.password = password
        userDataObject.password_confirmation = password
        userDataObject.phone = phone
        //userDataObject.social_unique_id = socialId
        
        
        return userDataObject
        
    }
    
    class func signUpViaSocial(loginBy : LoginType, email : String?,socialId : String? = nil, userName : String,phone: Int?,accessToken: String)->UserData {
        
        let userDataObject = UserData()
        userDataObject.email = email
        userDataObject.name = userName
        userDataObject.login_by = loginBy
        userDataObject.accessToken = accessToken
        userDataObject.phone = phone
        
        return userDataObject
        
    }
    
    
    // MARK:- Login
    
    class func login(withUser userName : String?, password : String?) -> Data?{
        
        var loginData = LoginRequestData()
        loginData.client_id = appClientId
        loginData.client_secret = appSecretKey
        loginData.grant_type = WebConstants.string.password
        loginData.password = password
        loginData.username = userName
        loginData.device_id = UUID().uuidString
        loginData.device_type = .ios
        loginData.device_token = deviceTokenString
        return loginData.toData()
    }
    
}




