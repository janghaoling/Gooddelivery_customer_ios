//
//  SignUpModel.swift
//  Goheavy
//
//  Created by CSS on 03/06/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation


struct SignUpMdel: JSONSerializable {
    var email:String?
    var mobile: String?
    var password: String?
    var first_name:String?
    var last_name:String?
    var country_code:String?
    var device_id:String?
    var device_type:String?
    var device_token:String?
    var login_by:String?
}
