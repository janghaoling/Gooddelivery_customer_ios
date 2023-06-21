//
//  CommonDelegate.swift
//  Project
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation


protocol countryDelegate {
      func didReceiveUserCountryDetails (countryDetails: Country?)
}

protocol  CartUpdateDelegate {
    func didReceiveAddCartUpdate()
}

protocol  AddCartUpdateDelegate {
    func didReceiveAddCartUpdate(isRefreshPage: Bool?)
}

protocol TapOnImageDelegate {
    
    func didTapOnImageView(isTapEnable: Bool?)
}

protocol ManageAddressDelegate {
    
    func didReceiveManageAddress(isUpdated: Bool?, address: String?, deliveryType: String?, addressId: Int?)
}

protocol SavedAddressDelegate {
    func didReceiveSavedAddress(isUpdated: Bool?, addressDetails: UserAddressDetails?)
}


protocol AddAddressDelegate {
    func didReceiveAddAddress(isUpdated: Bool?, addressDetails: UserAddressDetails?)
}


protocol CustomNotesDelegate {
    
    func didReceiveCustomNotes(isNoteAdded: Bool?, customNotes: String?)
}

protocol CardDetailDelegate {
    
    func didReceiveCartDetail(isUpdate: Bool?, cartDetail: Card?)
}

protocol OnBoardPageViewDelegate {
    
    func visibleIndex(index:Int)
}
