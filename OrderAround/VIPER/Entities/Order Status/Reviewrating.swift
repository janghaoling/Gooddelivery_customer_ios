//
//  Reviewrating.swift
//  orderAround
//
//  Created by Ansar on 07/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation

struct Reviewrating : Codable {
    let id : Int?
    let order_id : Int?
    let user_id : Int?
    let user_rating : Int?
    let user_comment : String?
    let transporter_id : Int?
    let transporter_rating : Int?
    let transporter_comment : String?
    let shop_id : Int?
    let shop_rating : Int?
    let shop_comment : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case order_id = "order_id"
        case user_id = "user_id"
        case user_rating = "user_rating"
        case user_comment = "user_comment"
        case transporter_id = "transporter_id"
        case transporter_rating = "transporter_rating"
        case transporter_comment = "transporter_comment"
        case shop_id = "shop_id"
        case shop_rating = "shop_rating"
        case shop_comment = "shop_comment"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        user_rating = try values.decodeIfPresent(Int.self, forKey: .user_rating)
        user_comment = try values.decodeIfPresent(String.self, forKey: .user_comment)
        transporter_id = try values.decodeIfPresent(Int.self, forKey: .transporter_id)
        transporter_rating = try values.decodeIfPresent(Int.self, forKey: .transporter_rating)
        transporter_comment = try values.decodeIfPresent(String.self, forKey: .transporter_comment)
        shop_id = try values.decodeIfPresent(Int.self, forKey: .shop_id)
        shop_rating = try values.decodeIfPresent(Int.self, forKey: .shop_rating)
        shop_comment = try values.decodeIfPresent(String.self, forKey: .shop_comment)
    }
    
}
