/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct Categories : Codable  {
	let id : Int?
	let parent_id : Int?
	let shop_id : Int?
	let name : String?
	let description : String?
	let position : Int?
	let status : String?
	let products : [Products]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case parent_id = "parent_id"
		case shop_id = "shop_id"
		case name = "name"
		case description = "description"
		case position = "position"
		case status = "status"
		case products = "products"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		parent_id = try values.decodeIfPresent(Int.self, forKey: .parent_id)
		shop_id = try values.decodeIfPresent(Int.self, forKey: .shop_id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		position = try values.decodeIfPresent(Int.self, forKey: .position)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		products = try values.decodeIfPresent([Products].self, forKey: .products)
	}

}
