/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Invoice : Codable {
	let id : Int?
	let order_id : Int?
	let quantity : Int?
	let paid : Int?
	let gross : Double?
	let discount : Double?
	let delivery_charge : Double?
	let wallet_amount : Double?
	let promocode_id : Int?
	let promocode_amount : Double?
	let payable : Double?
	let tax : Double?
	let net : Double?
	let total_pay : Double?
	let tender_pay : Double?
    let ripple_price : String?
    let destinationTag : String?
    let payment_mode : String?
    let payment_id : String?
    let status : String?
    let created_at : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case order_id = "order_id"
		case quantity = "quantity"
		case paid = "paid"
		case gross = "gross"
		case discount = "discount"
		case delivery_charge = "delivery_charge"
		case wallet_amount = "wallet_amount"
		case promocode_id = "promocode_id"
		case promocode_amount = "promocode_amount"
		case payable = "payable"
		case tax = "tax"
		case net = "net"
		case total_pay = "total_pay"
		case tender_pay = "tender_pay"
        case ripple_price = "ripple_price"
        case destinationTag = "DestinationTag"
        case payment_mode = "payment_mode"
        case payment_id = "payment_id"
        case status = "status"
        case created_at = "created_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
		quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
		paid = try values.decodeIfPresent(Int.self, forKey: .paid)
		gross = try values.decodeIfPresent(Double.self, forKey: .gross)
		discount = try values.decodeIfPresent(Double.self, forKey: .discount)
		delivery_charge = try values.decodeIfPresent(Double.self, forKey: .delivery_charge)
		wallet_amount = try values.decodeIfPresent(Double.self, forKey: .wallet_amount)
		promocode_id = try values.decodeIfPresent(Int.self, forKey: .promocode_id)
		promocode_amount = try values.decodeIfPresent(Double.self, forKey: .promocode_amount)
		payable = try values.decodeIfPresent(Double.self, forKey: .payable)
		tax = try values.decodeIfPresent(Double.self, forKey: .tax)
		net = try values.decodeIfPresent(Double.self, forKey: .net)
		total_pay = try values.decodeIfPresent(Double.self, forKey: .total_pay)
		tender_pay = try values.decodeIfPresent(Double.self, forKey: .tender_pay)
        ripple_price = try values.decodeIfPresent(String.self, forKey: .ripple_price)
        destinationTag = try values.decodeIfPresent(String.self, forKey: .destinationTag)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        payment_id = try values.decodeIfPresent(String.self, forKey: .payment_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
	}

}
