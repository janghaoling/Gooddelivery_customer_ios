//
//  MessageDetails.swift
//  orderAround
//
//  Created by Rajes on 14/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation


enum SenderType: String,Codable {
    case User = "user"
    case Support = "support"
}
struct MessageDetails:Codable {
    var message: String?
    var provider_id: String?
    var request_id: Int?
    var type: SenderType?
    var user_id: Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
        case provider_id = "provider_id"
        case request_id = "request_id"
        case type = "type"
        case user_id = "user_id"
       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        if let messageDetails = try values.decodeIfPresent(String.self, forKey: .message) {
            message = messageDetails
        } else {
            message = ""
        }
        if let providerID = try values.decodeIfPresent(String.self, forKey: .provider_id) {
            provider_id = providerID
        } else {
            provider_id = ""
        }
        if let requestID = try values.decodeIfPresent(Int.self, forKey: .request_id) {
            request_id = requestID
        } else {
            request_id = 0
        }
        if let senderType = try values.decodeIfPresent(SenderType.self, forKey: .type) {
            type = senderType
        } else {
            type = nil
        }
        if let userID = try values.decodeIfPresent(Int.self, forKey: .user_id) {
            user_id = userID
        } else {
            user_id = 0
        }
       
       
    }
}


