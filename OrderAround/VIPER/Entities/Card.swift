//
//  Card.swift
//  orderAround
//
//  Created by Deepika on 16/11/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation
struct Card : Codable {
    
    let cardid : Int?
    let card_type : String?
    let user_id : Int?
    let last_four : String?
    let card_id : String?
    let brand : String?
    let is_default : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case cardid = "id"
        case card_type = "card_type"
        case user_id = "user_id"
        case last_four = "last_four"
        case card_id = "card_id"
        case brand = "brand"
        case is_default = "is_default"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cardid = try values.decodeIfPresent(Int.self, forKey: .cardid)
        card_type = try values.decodeIfPresent(String.self, forKey: .card_type)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        last_four = try values.decodeIfPresent(String.self, forKey: .last_four)
        card_id = try values.decodeIfPresent(String.self, forKey: .card_id)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        is_default = try values.decodeIfPresent(Int.self, forKey: .is_default)
    }
    
}
