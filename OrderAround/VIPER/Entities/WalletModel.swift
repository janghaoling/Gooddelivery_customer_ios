//
//  WalletModel.swift
//  orderAround
//
//  Created by Rajes on 20/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation

struct WalletModel: Codable {
    var amount: String?
    var created_at: String?
    var deleted_at: String?
    var walletId: String?
    var message: String?
    var status: String?
    var user_id: Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case amount = "amount"
        case created_at = "created_at"
        case deleted_at = "deleted_at"
        case walletId = "walletId"
        case message = "message"
        case status = "status"
        case user_id = "user_id"
       
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
        walletId = try values.decodeIfPresent(String.self, forKey: .walletId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
   }


}
