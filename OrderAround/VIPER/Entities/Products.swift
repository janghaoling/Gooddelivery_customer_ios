/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Products : Codable {
    
	let id : Int?
	let shop_id : Int?
	let name : String?
	let description : String?
	let position : Int?
	let featured : Int?
	let featured_position : Int?
	let food_type : String?
	let avalability : Int?
	let max_quantity : Int?
	let status : String?
	let out_of_stock : String?
	let addon_status : Int?
	let prices : Prices?
	let images : [Images]?
	let addons : [Addons]?
    let cart : [Cart]?
    let carts : [Cart]?
    let shop : Shops?
    let shopstatus: String?
    

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case shop_id = "shop_id"
		case name = "name"
		case description = "description"
		case position = "position"
		case featured = "featured"
		case featured_position = "featured_position"
		case food_type = "food_type"
		case avalability = "avalability"
		case max_quantity = "max_quantity"
		case status = "status"
		case out_of_stock = "out_of_stock"
		case addon_status = "addon_status"
		case prices = "prices"
		case images = "images"
		case addons = "addons"
        case cart = "cart"
        case shop = "shop"
        case shopstatus = "shopstatus"
        case carts = "carts"


	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		shop_id = try values.decodeIfPresent(Int.self, forKey: .shop_id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		position = try values.decodeIfPresent(Int.self, forKey: .position)
		featured = try values.decodeIfPresent(Int.self, forKey: .featured)
		featured_position = try values.decodeIfPresent(Int.self, forKey: .featured_position)
		food_type = try values.decodeIfPresent(String.self, forKey: .food_type)
		avalability = try values.decodeIfPresent(Int.self, forKey: .avalability)
		max_quantity = try values.decodeIfPresent(Int.self, forKey: .max_quantity)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		out_of_stock = try values.decodeIfPresent(String.self, forKey: .out_of_stock)
		addon_status = try values.decodeIfPresent(Int.self, forKey: .addon_status)
		prices = try values.decodeIfPresent(Prices.self, forKey: .prices)
		images = try values.decodeIfPresent([Images].self, forKey: .images)
		addons = try? values.decode([Addons].self, forKey: .addons)
        cart = try values.decodeIfPresent([Cart].self, forKey: .cart)
        shop = try values.decodeIfPresent(Shops.self, forKey: .shop)
        shopstatus = try values.decodeIfPresent(String.self, forKey: .shopstatus)
        carts = try values.decodeIfPresent([Cart].self, forKey: .carts)

	}

}


struct ShopProduct : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let phone : String?
    let avatar : String?
    let status : String?
    let timings : [Timings]?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case avatar = "avatar"
        case status = "status"
        case timings = "timings"
        case created_at = "created_at"
        case updated_at = "updated_at"
        
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        timings = try values.decodeIfPresent([Timings].self, forKey: .timings)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)


    }
  
}
