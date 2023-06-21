/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Cart_addons : Codable {
	let id : Int?
	let user_cart_id : Int?
	let addon_product_id : Int?
	let quantity : Double?
	let deleted_at : String?
	let addon_product : Addon_product?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user_cart_id = "user_cart_id"
		case addon_product_id = "addon_product_id"
		case quantity = "quantity"
		case deleted_at = "deleted_at"
		case addon_product = "addon_product"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		user_cart_id = try values.decodeIfPresent(Int.self, forKey: .user_cart_id)
		addon_product_id = try values.decodeIfPresent(Int.self, forKey: .addon_product_id)
		quantity = try values.decodeIfPresent(Double.self, forKey: .quantity)
		deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
		addon_product = try values.decodeIfPresent(Addon_product.self, forKey: .addon_product)
	}

}
