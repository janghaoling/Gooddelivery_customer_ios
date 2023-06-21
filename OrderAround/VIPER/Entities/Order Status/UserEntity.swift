//
//  File.swift
//  orderAround
//
//  Created by Ansar on 07/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation

struct UserEntity : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let phone : String?
    let avatar : String?
    let device_token : String?
    let device_id : String?
    let device_type : String?
    let login_by : String?
    let social_unique_id : String?
    let stripe_cust_id : String?
    let wallet_balance : Int?
    let otp : String?
    let braintree_id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case avatar = "avatar"
        case device_token = "device_token"
        case device_id = "device_id"
        case device_type = "device_type"
        case login_by = "login_by"
        case social_unique_id = "social_unique_id"
        case stripe_cust_id = "stripe_cust_id"
        case wallet_balance = "wallet_balance"
        case otp = "otp"
        case braintree_id = "braintree_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        device_id = try values.decodeIfPresent(String.self, forKey: .device_id)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        login_by = try values.decodeIfPresent(String.self, forKey: .login_by)
        social_unique_id = try values.decodeIfPresent(String.self, forKey: .social_unique_id)
        stripe_cust_id = try values.decodeIfPresent(String.self, forKey: .stripe_cust_id)
        wallet_balance = try values.decodeIfPresent(Int.self, forKey: .wallet_balance)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        braintree_id = try values.decodeIfPresent(String.self, forKey: .braintree_id)
    }
    
}


struct Transporter : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let phone : String?
    let avatar : String?
    let device_token : String?
    let device_id : String?
    let device_type : String?
    let address : String?
    let latitude:Double?
    let longitude:Double?
    let status:String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case avatar = "avatar"
        case device_token = "device_token"
        case device_id = "device_id"
        case device_type = "device_type"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        device_id = try values.decodeIfPresent(String.self, forKey: .device_id)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
}


struct Vehicle : Codable {
    let id : Int?
    let transporter_id : Int?
    let vehicle_no : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case transporter_id = "transporter_id"
        case vehicle_no = "vehicle_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        transporter_id = try values.decodeIfPresent(Int.self, forKey: .transporter_id)
        vehicle_no = try values.decodeIfPresent(String.self, forKey: .vehicle_no)
    }
}
