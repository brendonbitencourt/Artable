//
//  Product.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-11-09.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    
    var name: String
    var id: String
    var category: String
    var price: Double
    var desc: String
    var imageUrl: String
    var timestamp: Timestamp
    var stock: Int
    
    init (name: String, id: String, category: String, price: Double, desc: String, imageUrl: String, timestamp: Timestamp = Timestamp(), stock: Int = 0) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.desc = desc
        self.imageUrl = imageUrl
        self.timestamp = timestamp
        self.stock = stock
    }
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.desc = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    
    static func modelToData(product: Product) -> [String: Any] {
        let data: [String: Any] = [
            "name": product.name,
            "id": product.id,
            "category": product.category,
            "price": product.price,
            "productDescription": product.desc,
            "imageUrl": product.imageUrl,
            "timestamp": product.timestamp,
            "stock": product.stock,
        ]
        return data
    }
    
}

extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
