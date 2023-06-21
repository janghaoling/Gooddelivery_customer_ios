/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Disputes : Codable {
	let id : Int?
	let order_id : Int?
	let order_disputehelp_id : Int?
	let user_id : Int?
	let transporter_id : Int?
	let shop_id : Int?
	let type : String?
	let created_by : String?
	let created_to : String?
	let status : String?
	let description : String?
	let created_at : String?
	let dispute_help : String?
	let disputecomment : [String]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case order_id = "order_id"
		case order_disputehelp_id = "order_disputehelp_id"
		case user_id = "user_id"
		case transporter_id = "transporter_id"
		case shop_id = "shop_id"
		case type = "type"
		case created_by = "created_by"
		case created_to = "created_to"
		case status = "status"
		case description = "description"
		case created_at = "created_at"
		case dispute_help = "dispute_help"
		case disputecomment = "disputecomment"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
		order_disputehelp_id = try values.decodeIfPresent(Int.self, forKey: .order_disputehelp_id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		transporter_id = try values.decodeIfPresent(Int.self, forKey: .transporter_id)
		shop_id = try values.decodeIfPresent(Int.self, forKey: .shop_id)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
		created_to = try values.decodeIfPresent(String.self, forKey: .created_to)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		dispute_help = try values.decodeIfPresent(String.self, forKey: .dispute_help)
		disputecomment = try values.decodeIfPresent([String].self, forKey: .disputecomment)
	}

}