//
//  PromoCode.swift
//  orderAround
//
//  Created by Ansar on 28/01/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation

struct PromoCodeEntity : Codable {
    
    let id : Int?
    let promo_code : String?
    let promocode_type : String?
    let discount : Double?
    let coupon_limit : Int?
    let avail_from : String?
    let expiration : String?
    let status : String?
    let promostatus : Int?
    let wallet_balance : Double?
//    let usage : Usage?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case promo_code = "promo_code"
        case promocode_type = "promocode_type"
        case discount = "discount"
        case coupon_limit = "coupon_limit"
        case avail_from = "avail_from"
        case status = "status"
        case promostatus = "promostatus"
        case expiration = "expiration"
        case wallet_balance = "wallet_balance"
//        case usage = "pusage"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        promo_code = try values.decodeIfPresent(String.self, forKey: .promo_code)
        promocode_type = try values.decodeIfPresent(String.self, forKey: .promocode_type)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        coupon_limit = try values.decodeIfPresent(Int.self, forKey: .coupon_limit)
        avail_from = try values.decodeIfPresent(String.self, forKey: .avail_from)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        promostatus = try values.decodeIfPresent(Int.self, forKey: .promostatus)
        expiration = try values.decodeIfPresent(String.self, forKey: .expiration)
        wallet_balance = try values.decodeIfPresent(Double.self, forKey: .wallet_balance)
        
//        usage = try values.decodeIfPresent(Usage.self, forKey: .usage)
    }
}

struct Usage : Codable {
    
    let id : Int?
    let promocode_id : String?
    let user_id : Int?
    let status : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case promocode_id = "promocode_id"
        case user_id = "user_id"
        case status = "status"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        promocode_id = try values.decodeIfPresent(String.self, forKey: .promocode_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

