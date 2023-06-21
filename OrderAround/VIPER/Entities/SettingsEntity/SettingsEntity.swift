/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentatvarrfiles (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SettingsEntity: Codable {
	let site_title : String?
	let site_logo : String?
	let site_favicon : String?
	let site_copyright : String?
	let delivery_charge : String?
	let resturant_response_time : String?
	let currency : String?
	let currency_code : String?
	let search_distance : String?
	let tax : String?
	let payment_mode : String?
	let manual_assign : String?
	let transporter_response_time : String?
	let tWILIO_SID : String?
	let tWILIO_TOKEN : String?
	let tWILIO_FROM : String?
	let pUBNUB_PUB_KEY : String?
	let pUBNUB_SUB_KEY : String?
	let stripe_charge : String?
	let stripe_publishable_key : String?
	let stripe_secret_key : String?
	let fB_CLIENT_ID : String?
	let fB_CLIENT_SECRET : String?
	let fB_REDIRECT : String?
	let gOOGLE_CLIENT_ID : String?
	let gOOGLE_CLIENT_SECRET : String?
	let gOOGLE_REDIRECT : String?
	let gOOGLE_API_KEY : String?
	let aNDROID_ENV : String?
	let aNDROID_PUSH_KEY : String?
	let iOS_USER_ENV : String?
	let iOS_PROVIDER_ENV : String?
	let dEMO_MODE : String?
	let sUB_CATEGORY : String?
	let sCHEDULE_ORDER : String?
	let client_id : String?
	let client_secret : String?
	let pRODUCT_ADDONS : String?
	let bRAINTREE_ENV : String?
	let bRAINTREE_MERCHANT_ID : String?
	let bRAINTREE_PUBLIC_KEY : String?
	let bRAINTREE_PRIVATE_KEY : String?
	let rIPPLE_KEY : String?
	let rIPPLE_BARCODE : String?
	let eTHER_ADMIN_KEY : String?
	let eTHER_KEY : String?
	let eTHER_BARCODE : String?
	let cLIENT_AUTHORIZATION : String?
	let sOCIAL_FACEBOOK_LINK : String?
	let sOCIAL_TWITTER_LINK : String?
	let sOCIAL_G_PLUS_LINK : String?
	let sOCIAL_INSTAGRAM_LINK : String?
	let sOCIAL_PINTEREST_LINK : String?
	let sOCIAL_VIMEO_LINK : String?
	let sOCIAL_YOUTUBE_LINK : String?
	let cOMMISION_OVER_FOOD : String?
	let cOMMISION_OVER_DELIVERY_FEE : String?
	let iOS_APP_LINK : String?
	let aNDROID_APP_LINK : String?
	let default_lang : String?
	let testing : String?
	let faq : String?
	let contact : String?
	let terms : String?
	let about : String?
	let privacy : String?
	let price : String?
	let android_api_key : String?
	let ios_api_key : String?

	enum CodingKeys: String, CodingKey {

		case site_title = "site_title"
		case site_logo = "site_logo"
		case site_favicon = "site_favicon"
		case site_copyright = "site_copyright"
		case delivery_charge = "delivery_charge"
		case resturant_response_time = "resturant_response_time"
		case currency = "currency"
		case currency_code = "currency_code"
		case search_distance = "search_distance"
		case tax = "tax"
		case payment_mode = "payment_mode"
		case manual_assign = "manual_assign"
		case transporter_response_time = "transporter_response_time"
		case tWILIO_SID = "TWILIO_SID"
		case tWILIO_TOKEN = "TWILIO_TOKEN"
		case tWILIO_FROM = "TWILIO_FROM"
		case pUBNUB_PUB_KEY = "PUBNUB_PUB_KEY"
		case pUBNUB_SUB_KEY = "PUBNUB_SUB_KEY"
		case stripe_charge = "stripe_charge"
		case stripe_publishable_key = "stripe_publishable_key"
		case stripe_secret_key = "stripe_secret_key"
		case fB_CLIENT_ID = "FB_CLIENT_ID"
		case fB_CLIENT_SECRET = "FB_CLIENT_SECRET"
		case fB_REDIRECT = "FB_REDIRECT"
		case gOOGLE_CLIENT_ID = "GOOGLE_CLIENT_ID"
		case gOOGLE_CLIENT_SECRET = "GOOGLE_CLIENT_SECRET"
		case gOOGLE_REDIRECT = "GOOGLE_REDIRECT"
		case gOOGLE_API_KEY = "GOOGLE_API_KEY"
		case aNDROID_ENV = "ANDROID_ENV"
		case aNDROID_PUSH_KEY = "ANDROID_PUSH_KEY"
		case iOS_USER_ENV = "IOS_USER_ENV"
		case iOS_PROVIDER_ENV = "IOS_PROVIDER_ENV"
		case dEMO_MODE = "DEMO_MODE"
		case sUB_CATEGORY = "SUB_CATEGORY"
		case sCHEDULE_ORDER = "SCHEDULE_ORDER"
		case client_id = "client_id"
		case client_secret = "client_secret"
		case pRODUCT_ADDONS = "PRODUCT_ADDONS"
		case bRAINTREE_ENV = "BRAINTREE_ENV"
		case bRAINTREE_MERCHANT_ID = "BRAINTREE_MERCHANT_ID"
		case bRAINTREE_PUBLIC_KEY = "BRAINTREE_PUBLIC_KEY"
		case bRAINTREE_PRIVATE_KEY = "BRAINTREE_PRIVATE_KEY"
		case rIPPLE_KEY = "RIPPLE_KEY"
		case rIPPLE_BARCODE = "RIPPLE_BARCODE"
		case eTHER_ADMIN_KEY = "ETHER_ADMIN_KEY"
		case eTHER_KEY = "ETHER_KEY"
		case eTHER_BARCODE = "ETHER_BARCODE"
		case cLIENT_AUTHORIZATION = "CLIENT_AUTHORIZATION"
		case sOCIAL_FACEBOOK_LINK = "SOCIAL_FACEBOOK_LINK"
		case sOCIAL_TWITTER_LINK = "SOCIAL_TWITTER_LINK"
		case sOCIAL_G_PLUS_LINK = "SOCIAL_G-PLUS_LINK"
		case sOCIAL_INSTAGRAM_LINK = "SOCIAL_INSTAGRAM_LINK"
		case sOCIAL_PINTEREST_LINK = "SOCIAL_PINTEREST_LINK"
		case sOCIAL_VIMEO_LINK = "SOCIAL_VIMEO_LINK"
		case sOCIAL_YOUTUBE_LINK = "SOCIAL_YOUTUBE_LINK"
		case cOMMISION_OVER_FOOD = "COMMISION_OVER_FOOD"
		case cOMMISION_OVER_DELIVERY_FEE = "COMMISION_OVER_DELIVERY_FEE"
		case iOS_APP_LINK = "IOS_APP_LINK"
		case aNDROID_APP_LINK = "ANDROID_APP_LINK"
		case default_lang = "default_lang"
		case testing = "testing"
		case faq = "faq"
		case contact = "contact"
		case terms = "terms"
		case about = "about"
		case privacy = "privacy"
		case price = "price"
		case android_api_key = "android_api_key"
		case ios_api_key = "ios_api_key"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		site_title = try values.decodeIfPresent(String.self, forKey: .site_title)
		site_logo = try values.decodeIfPresent(String.self, forKey: .site_logo)
		site_favicon = try values.decodeIfPresent(String.self, forKey: .site_favicon)
		site_copyright = try values.decodeIfPresent(String.self, forKey: .site_copyright)
		delivery_charge = try values.decodeIfPresent(String.self, forKey: .delivery_charge)
		resturant_response_time = try values.decodeIfPresent(String.self, forKey: .resturant_response_time)
		currency = try values.decodeIfPresent(String.self, forKey: .currency)
		currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
		search_distance = try values.decodeIfPresent(String.self, forKey: .search_distance)
		tax = try values.decodeIfPresent(String.self, forKey: .tax)
		payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
		manual_assign = try values.decodeIfPresent(String.self, forKey: .manual_assign)
		transporter_response_time = try values.decodeIfPresent(String.self, forKey: .transporter_response_time)
        tWILIO_SID = try values.decodeIfPresent(String.self, forKey: .tWILIO_SID)
		tWILIO_TOKEN = try values.decodeIfPresent(String.self, forKey: .tWILIO_TOKEN)
		tWILIO_FROM = try values.decodeIfPresent(String.self, forKey: .tWILIO_FROM)
		pUBNUB_PUB_KEY = try values.decodeIfPresent(String.self, forKey: .pUBNUB_PUB_KEY)
		pUBNUB_SUB_KEY = try values.decodeIfPresent(String.self, forKey: .pUBNUB_SUB_KEY)
		stripe_charge = try values.decodeIfPresent(String.self, forKey: .stripe_charge)
        stripe_publishable_key = try values.decodeIfPresent(String.self, forKey: .stripe_publishable_key)
		stripe_secret_key = try values.decodeIfPresent(String.self, forKey: .stripe_secret_key)
        fB_CLIENT_ID = try values.decodeIfPresent(String.self, forKey: .fB_CLIENT_ID)
        fB_CLIENT_SECRET = try values.decodeIfPresent(String.self, forKey: .fB_CLIENT_SECRET)
        fB_REDIRECT = try values.decodeIfPresent(String.self, forKey: .fB_REDIRECT)
        gOOGLE_CLIENT_ID = try values.decodeIfPresent(String.self, forKey: .gOOGLE_CLIENT_ID)
        gOOGLE_CLIENT_SECRET = try values.decodeIfPresent(String.self, forKey: .gOOGLE_CLIENT_SECRET)
        gOOGLE_REDIRECT = try values.decodeIfPresent(String.self, forKey: .gOOGLE_REDIRECT)
        gOOGLE_API_KEY = try values.decodeIfPresent(String.self, forKey: .gOOGLE_API_KEY)
        aNDROID_ENV = try values.decodeIfPresent(String.self, forKey: .aNDROID_ENV)
		aNDROID_PUSH_KEY = try values.decodeIfPresent(String.self, forKey: .aNDROID_PUSH_KEY)
		iOS_USER_ENV = try values.decodeIfPresent(String.self, forKey: .iOS_USER_ENV)
		iOS_PROVIDER_ENV = try values.decodeIfPresent(String.self, forKey: .iOS_PROVIDER_ENV)
		dEMO_MODE = try values.decodeIfPresent(String.self, forKey: .dEMO_MODE)
		sUB_CATEGORY = try values.decodeIfPresent(String.self, forKey: .sUB_CATEGORY)
		sCHEDULE_ORDER = try values.decodeIfPresent(String.self, forKey: .sCHEDULE_ORDER)
		client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
		client_secret = try values.decodeIfPresent(String.self, forKey: .client_secret)
		pRODUCT_ADDONS = try values.decodeIfPresent(String.self, forKey: .pRODUCT_ADDONS)
		bRAINTREE_ENV = try values.decodeIfPresent(String.self, forKey: .bRAINTREE_ENV)
		bRAINTREE_MERCHANT_ID = try values.decodeIfPresent(String.self, forKey: .bRAINTREE_MERCHANT_ID)
		bRAINTREE_PUBLIC_KEY = try values.decodeIfPresent(String.self, forKey: .bRAINTREE_PUBLIC_KEY)
        bRAINTREE_PRIVATE_KEY = try values.decodeIfPresent(String.self, forKey: .bRAINTREE_PRIVATE_KEY)
        rIPPLE_KEY = try values.decodeIfPresent(String.self, forKey: .rIPPLE_KEY)
        rIPPLE_BARCODE = try values.decodeIfPresent(String.self, forKey: .rIPPLE_BARCODE)
        eTHER_ADMIN_KEY = try values.decodeIfPresent(String.self, forKey: .eTHER_ADMIN_KEY)
        eTHER_KEY = try values.decodeIfPresent(String.self, forKey: .eTHER_KEY)
        eTHER_BARCODE = try values.decodeIfPresent(String.self, forKey: .eTHER_BARCODE)
        cLIENT_AUTHORIZATION = try values.decodeIfPresent(String.self, forKey: .cLIENT_AUTHORIZATION)
        sOCIAL_FACEBOOK_LINK = try values.decodeIfPresent(String.self, forKey: .sOCIAL_FACEBOOK_LINK)
        sOCIAL_TWITTER_LINK = try values.decodeIfPresent(String.self, forKey: .sOCIAL_TWITTER_LINK)
		sOCIAL_G_PLUS_LINK = try values.decodeIfPresent(String.self, forKey: .sOCIAL_G_PLUS_LINK)
		sOCIAL_INSTAGRAM_LINK = try values.decodeIfPresent(String.self, forKey: .sOCIAL_INSTAGRAM_LINK)
        sOCIAL_PINTEREST_LINK = try values.decodeIfPresent(String.self, forKey: .sOCIAL_PINTEREST_LINK)
		sOCIAL_VIMEO_LINK = try values.decodeIfPresent(String.self, forKey: .sOCIAL_VIMEO_LINK)
		sOCIAL_YOUTUBE_LINK = try values.decodeIfPresent(String.self, forKey: .sOCIAL_YOUTUBE_LINK)
		cOMMISION_OVER_FOOD = try values.decodeIfPresent(String.self, forKey: .cOMMISION_OVER_FOOD)
		cOMMISION_OVER_DELIVERY_FEE = try values.decodeIfPresent(String.self, forKey: .cOMMISION_OVER_DELIVERY_FEE)
		iOS_APP_LINK = try values.decodeIfPresent(String.self, forKey: .iOS_APP_LINK)
		aNDROID_APP_LINK = try values.decodeIfPresent(String.self, forKey: .aNDROID_APP_LINK)
		default_lang = try values.decodeIfPresent(String.self, forKey: .default_lang)
		testing = try values.decodeIfPresent(String.self, forKey: .testing)
		faq = try values.decodeIfPresent(String.self, forKey: .faq)
		contact = try values.decodeIfPresent(String.self, forKey: .contact)
		terms = try values.decodeIfPresent(String.self, forKey: .terms)
		about = try values.decodeIfPresent(String.self, forKey: .about)
		privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		android_api_key = try values.decodeIfPresent(String.self, forKey: .android_api_key)
		ios_api_key = try values.decodeIfPresent(String.self, forKey: .ios_api_key)
	}

}
