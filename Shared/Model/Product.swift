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
    var favorite: Bool
    
}
