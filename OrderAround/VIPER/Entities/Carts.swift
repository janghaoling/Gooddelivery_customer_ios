import Foundation
struct Carts : Codable {
    let id : Int?
    let product_id : Int?
    let promocode_id : String?
    let order_id : String?
    let quantity : Int?
    let note : String?
    let savedforlater : Int?
    let product : Product?
    let cart_addons : [String]?
    
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
        order_id = try values.decodeIfPresent(String.self, forKey: .order_id)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        savedforlater = try values.decodeIfPresent(Int.self, forKey: .savedforlater)
        product = try values.decodeIfPresent(Product.self, forKey: .product)
        cart_addons = try values.decodeIfPresent([String].self, forKey: .cart_addons)
    }
    
}

