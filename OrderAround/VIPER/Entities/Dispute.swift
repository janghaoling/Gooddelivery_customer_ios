//
//  DisputeHelp.swift
//  orderAround
//
//  Created by Ansar on 14/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation


struct Dispute : Codable {
    
    let id : Int?
    let name : String?
    let type : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case type = "type"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
}
