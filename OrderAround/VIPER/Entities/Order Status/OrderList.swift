//
//  OrderList.swift
//  orderAround
//
//  Created by Ansar on 07/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation


struct OrderList : Codable {
    let id : Int?
    let invoice_id : String?
    let user_id : Int?
    let user_address_id : Int?
    let shop_id : Int?
    let transporter_id : Int?
    let transporter_vehicle_id : Int?
    let reason : String?
    let note : String?
    let route_key : String?
    let dispute : String?
    let delivery_date : String?
    let order_otp : Int?
    let order_ready_time : Int?
    let order_ready_status : Int?
    let status : String?
    let schedule_status : Int?
    let created_at : String?
    
    
    let user : UserEntity?
    let transporter : Transporter? //dictionary
    let vehicles : Vehicle?
    
    let invoice : Invoice?
    let address : Addresses?
    let shop : Shop?
    let items : [Items]?
    let ordertiming : [Ordertiming]?
    let disputes : [Disputes]?
    var reviewrating : Reviewrating?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case invoice_id = "invoice_id"
        case user_id = "user_id"
        case user_address_id = "user_address_id"
        case shop_id = "shop_id"
        case transporter_id = "transporter_id"
        case transporter_vehicle_id = "transporter_vehicle_id"
        case reason = "reason"
        case note = "note"
        case route_key = "route_key"
        case dispute = "dispute"
        case delivery_date = "delivery_date"
        case order_otp = "order_otp"
        case order_ready_time = "order_ready_time"
        case order_ready_status = "order_ready_status"
        case status = "status"
        case schedule_status = "schedule_status"
        case created_at = "created_at"
        
        
        case user = "user"
        case transporter = "transporter"
        case vehicles = "vehicles"
        
        case invoice = "invoice"
        case address = "address"
        case shop = "shop"
        case items = "items"
        case ordertiming = "ordertiming"
        case disputes = "disputes"
        case reviewrating = "reviewrating"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        user_address_id = try values.decodeIfPresent(Int.self, forKey: .user_address_id)
        shop_id = try values.decodeIfPresent(Int.self, forKey: .shop_id)
        transporter_id = try values.decodeIfPresent(Int.self, forKey: .transporter_id)
        transporter_vehicle_id = try values.decodeIfPresent(Int.self, forKey: .transporter_vehicle_id)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        
        
        route_key = try values.decodeIfPresent(String.self, forKey: .route_key)
        dispute = try values.decodeIfPresent(String.self, forKey: .dispute)
        delivery_date = try values.decodeIfPresent(String.self, forKey: .delivery_date)
        order_otp = try values.decodeIfPresent(Int.self, forKey: .order_otp)
        order_ready_time = try values.decodeIfPresent(Int.self, forKey: .order_ready_time)
        order_ready_status = try values.decodeIfPresent(Int.self, forKey: .order_ready_status)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        schedule_status = try values.decodeIfPresent(Int.self, forKey: .schedule_status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        
        
        user = try values.decodeIfPresent(UserEntity.self, forKey: .user)
        transporter = try values.decodeIfPresent(Transporter.self, forKey: .transporter)
        vehicles = try values.decodeIfPresent(Vehicle.self, forKey: .vehicles)
        
        invoice = try values.decodeIfPresent(Invoice.self, forKey: .invoice)
        address = try values.decodeIfPresent(Addresses.self, forKey: .address)
        shop = try values.decodeIfPresent(Shop.self, forKey: .shop)
        items = try values.decodeIfPresent([Items].self, forKey: .items)
        ordertiming = try values.decodeIfPresent([Ordertiming].self, forKey: .ordertiming)
        disputes = try values.decodeIfPresent([Disputes].self, forKey: .disputes)
        reviewrating = try values.decodeIfPresent(Reviewrating.self, forKey: .reviewrating)
    }
    
}
