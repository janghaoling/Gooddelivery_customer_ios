/*
 Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
struct Json4Swift_Base : Codable {
    let shops : [Shops]?
    let banners : [Banners]?
    let currency : String?
    
    enum CodingKeys: String, CodingKey {
        
        case shops = "shops"
        case banners = "banners"
        case currency = "currency"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shops = try values.decodeIfPresent([Shops].self, forKey: .shops)
        banners = try values.decodeIfPresent([Banners].self, forKey: .banners)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
    }
    
}


struct ResturantMenuList: Codable {
    
    let categories : [Categories]?
    let featured_products : [Featured_products]?
    
    enum CodingKeys: String, CodingKey {
        
        case categories = "categories"
        case featured_products = "featured_products"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
        featured_products = try values.decodeIfPresent([Featured_products].self, forKey: .featured_products)
    }
    
}


struct CartList: Codable {
    
    
    let delivery_charges : String?
    let delivery_free_minimum : Int?
    let tax_percentage : String?
    let carts : [Items]?
    let total_price: Double?
    let net: Double?
    enum CodingKeys: String, CodingKey {
        
        case delivery_charges = "delivery_charges"
        case delivery_free_minimum = "delivery_free_minimum"
        case tax_percentage = "tax_percentage"
        case carts = "carts"
        case total_price = "total_price"
        case net = "net"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        delivery_charges = try values.decodeIfPresent(String.self, forKey: .delivery_charges)
        delivery_free_minimum = try values.decodeIfPresent(Int.self, forKey: .delivery_free_minimum)
        tax_percentage = try values.decodeIfPresent(String.self, forKey: .tax_percentage)
        carts = try values.decodeIfPresent([Items].self, forKey: .carts)
        total_price = try values.decodeIfPresent(Double.self, forKey: .total_price)
        net = try values.decodeIfPresent(Double.self, forKey: .net)
    }
    //    let carts: [CartItem]?
    //
    //    enum CodingKeys: String, CodingKey {
    //
    //        case carts = "carts"
    //
    //    }
    //
    //    init(from decoder: Decoder) throws {
    //        let values = try decoder.container(keyedBy: CodingKeys.self)
    //        carts = try values.decodeIfPresent([CartItem].self, forKey: .carts)
    //
}


struct CartItem: Codable {
    
    let quantity:Int?
    let products : Product?
    
    
    enum CodingKeys: String, CodingKey {
        
        case quantity = "quantity"
        case products = "product"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        products = try values.decodeIfPresent(Product.self, forKey: .products)
        
    }
}



struct CartListItem : Codable {
    
    let delivery_charges : String?
    let delivery_free_minimum : Int?
    let tax_percentage : String?
    let carts : [Carts]?
    
    enum CodingKeys: String, CodingKey {
        
        case delivery_charges = "delivery_charges"
        case delivery_free_minimum = "delivery_free_minimum"
        case tax_percentage = "tax_percentage"
        case carts = "carts"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        delivery_charges = try values.decodeIfPresent(String.self, forKey: .delivery_charges)
        delivery_free_minimum = try values.decodeIfPresent(Int.self, forKey: .delivery_free_minimum)
        tax_percentage = try values.decodeIfPresent(String.self, forKey: .tax_percentage)
        carts = try values.decodeIfPresent([Carts].self, forKey: .carts)
    }
    
}

struct SearchProducts:Codable {
    let products : [Products]?
    let shop : [Shops]?
    
    enum CodingKeys: String, CodingKey {
        
        case products = "products"
        case shop = "shops"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
        shop = try values.decodeIfPresent([Shops].self, forKey: .shop)
    }
}



struct FavouriteList: Codable {
    
    var available: [FavouriteShop]?
    var un_available: [FavouriteShop]?
    
    enum CodingKeys: String, CodingKey {
        
        case available = "available"
        case un_available = "un_available"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        available = try values.decodeIfPresent([FavouriteShop].self, forKey: .available)
        un_available = try values.decodeIfPresent([FavouriteShop].self, forKey: .un_available)
    }
    
}


struct FavouriteShop :  Codable {
    
    var id: Int?
    var shop: Shops?
    var shopId : Int?
    var userId : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case shop = "shop"
        case shopId = "shop_id"
        case userId = "user_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        shop = try values.decodeIfPresent(Shops.self, forKey: .shop)
        shopId = try values.decodeIfPresent(Int.self, forKey: .shopId)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}
