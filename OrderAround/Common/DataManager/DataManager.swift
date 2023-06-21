//
//  DataManager.swift
//  orderAround
//
//  Created by Rajes on 20/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation

class DataManager {
    
    private var profileDetails:UserProfileDetails!
    
    private var userAddressArray:[UserAddressDetails]!
    
    private var selectedAddress:UserAddressDetails!
    
    static var shared = DataManager()
    
    
    
    func setUserAddressDetails(addressArray:[UserAddressDetails]) {
        self.userAddressArray = addressArray
    }
    
    func getSavedAddressArray() -> [UserAddressDetails]? {
        return userAddressArray
    }
    
    func setSelectedAddress(address:UserAddressDetails) {
        self.selectedAddress = address
    }
    
    func getSelectedAddressDetails() -> UserAddressDetails? {
        return self.selectedAddress
    }
}

