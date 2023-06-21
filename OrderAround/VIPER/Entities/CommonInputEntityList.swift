//
//  CommonInputEntityList.swift
//  Project
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation

class GetOTP : JSONSerializable {

    var phone : String?
    var forgot : String?
    var login_by : String?
    var accessToken : String?
    var otp : String?
    
}

//struct  LoginRequest : JSONSerializable {
//    
//    var grant_type : String?
//    var username : String?
//    var password : String?
//    var client_id : Int?
//    var client_secret : String?
//    var access_token : String?
//    var refresh_token : String?
//    var device_token : String?
//    var device_id : String?
//    var device_type : DeviceType?
//    var login_by: LoginType
//    var accessToken: String?
//    
//}

struct  LoginRequestData : JSONSerializable {
    
    var grant_type : String?
    var username : String?
    var password : String?
    var client_id : Int?
    var client_secret : String?
    var access_token : String?
    var refresh_token : String?
    var device_token : String?
    var device_id : String?
    var device_type : DeviceType?
    var login_by: LoginType?
    var accessToken: String?
    
}



struct SocialLogin: JSONSerializable {
    
    var name: String?
    var email: String?
    var phone: String?
    var login_by: String?
    var accessToken: String?
    
    init(name: String,email: String, phone: String, login_by: String, accessToken: String) {
        
        self.name = name
        self.email = email
        self.phone = phone
        self.login_by = login_by
        self.accessToken = accessToken
    }
    
}

struct UserCurrentLocation: JSONSerializable {
    
    var latitude: Double?
    var longitude: Double?
    var user_id: Int?
    
    var cuisine:[String]?
    var pure_veg:Int?
    var offer:Int?
  
}

struct CategoriesList: JSONSerializable {
    
    var shop: Int?
    var user_id: Int?
}


struct  DoFavourites : JSONSerializable {
    
    var shop_id: Int?
}

struct AddCart: JSONSerializable {
    
    var product_id: Int?
    var quantity: Int?
    var cart_id: Int?
    var addons_qty: [Int]?
    var product_addons: [Int]?
    
}

struct UserAddressInfo: JSONSerializable {
    
     var building: String?
     var street: String?
     var city: String?
     var state: String?
     var country: String?
     var pincode: String?
     var landmark: String?
     var map_address: String?
     var latitude: String?
     var longitude: String?
     var type: String?
     var update: String?
}

struct UserCardInfo: JSONSerializable {
    
    var stripe_token: String?
    
}


struct UserOrderCheckOutInfo: JSONSerializable {
    
    var user_address_id: Int?
    var wallet: Int?
    var payment_mode: String?
    var note: String?
    var card_id: Int?
    var delivery_date: String?
    var promocode_id: Int?

}

//Apply Promocode

struct ApplyPromoCode : JSONSerializable {
    var promocode_id : Int?
//    var delivery_charges : String?
//    var delivery_free_minimum : Int?
//    var tax_percentage : String?
//    var carts : [Items]?
//    var total_price: Double?
}


//Change Password

struct ChangePassword : JSONSerializable {
    var password_old : String?
    var password : String?
    var password_confirmation : String?
}


//Reorder

struct Reorder:JSONSerializable {
    var order_id:Int?
}

//Feedback

struct Feedback:JSONSerializable {
    // NSDictionary * params = @{@"order_id":orderIdStr,@"rating":feedBackRatingStr,@"comment":self.commentTextView.text,@"type":@"transporter"};
    var order_id:Int?
    var rating:Int?
    var comment:String?
    var type:String?
}


//Create Dispute

struct CreateDispute:JSONSerializable {
    var order_id : Int?
    var status : String?
    var description : String?
    var dispute_type : String?
    var created_by:String?
    var created_to:String?
}


//Cancel

struct CancelOrder:JSONSerializable {
    var reason : String?
    
}
