//
//  SavedLocation.swift
//  Project
//
//  Created by CSS on 25/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation

class UserAddressDetails: JSONSerializable {
    
    var id: Int?
    var user_id: Int?
    var building: String?
    var street: String?
    var city: String?
    var state: String?
    var country: String?
    var pincode: String?
    var landmark: String?
    var map_address: String?
    var latitude: Double?
    var longitude: Double?
    var type: String?
    
}

class PaymentMode : JSONSerializable {
    
    var CASH: String?
    var STRIPE: String?
}
