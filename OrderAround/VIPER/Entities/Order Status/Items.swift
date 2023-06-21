/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Items : Codable {
	let id : Int?
	let product_id : Int?
	let promocode_id : String?
	let order_id : Int?
	let quantity : Double?
	let note : String?
	let savedforlater : Int?
	let product : Products?
	let cart_addons : [Cart_addons]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case product_id = "product_id"
		case promocode_id = "promocode_id"
		case order_id = "order_id"
		case quantity = "quantity"
		case note = "note"
		case savedforlater = "savedforlater"
		case product = "product"
		case cart_addons = "cart_addons"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
		promocode_id = try values.decodeIfPresent(String.self, forKey: .promocode_id)
		order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
		quantity = try values.decodeIfPresent(Double.self, forKey: .quantity)
		note = try values.decodeIfPresent(String.self, forKey: .note)
		savedforlater = try values.decodeIfPresent(Int.self, forKey: .savedforlater)
		product = try values.decodeIfPresent(Products.self, forKey: .product)
		cart_addons = try values.decodeIfPresent([Cart_addons].self, forKey: .cart_addons)
	}

}
