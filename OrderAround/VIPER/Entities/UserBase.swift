//
//  UserBase.swift
//  Project
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation

protocol UserBase : JSONSerializable {
    
    var id : Int? { get }
    var first_name : String? { get }
    var last_name : String? { get }
    var email : String? { get }
    var mobile : Int? { get }
}


class UserData : UserBase {
    
    var first_name: String?
    var last_name: String?
    var mobile: Int?
    var id : Int?
    var name : String?    
    var email : String?
    var phone : Int?
    var accessToken : String?
    var device_type : DeviceType?
    var device_token : String?
    var login_by : LoginType?
    var password : String?
    var old_password : String?
    var password_confirmation : String?
    var social_unique_id : String?
    var device_id : String?
    var otp : Int?
    var grant_type: String?
    
}

class ForgotResponse : JSONSerializable {
    
    var user : UserDataResponse?
}

class UserDataResponse : JSONSerializable {
    
    var id : Int?
    var email : String?
    var device_type : DeviceType?
    var device_token : String?
    var login_by : LoginType?
    var password : String?
    var old_password : String?
    var password_confirmation : String?
    var social_unique_id : String?
    var device_id : String?
    var otp : Int?
    
}

class UserLocation: JSONSerializable {
    var userLocationData : [UserLocationData]
}

class UserLocationData: JSONSerializable {
    var type:String?
    var address:String?
}

class SearchProduct : JSONSerializable {
    var name:String?
    var user_id:Int?
}

