//
//  Category.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-11-01.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    
    var name: String
    var id: String
    var imageUrl: String
    var isActive: Bool
    var timestamp: Timestamp
    
    init (name: String, id: String, imageUrl: String, isActive: Bool = true, timestamp: Timestamp) {
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
        self.isActive = isActive
        self.timestamp = timestamp
    }
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(category: Category) -> [String: Any] {
        let data: [String: Any] = [
            "name": category.name,
            "id": category.id,
            "imageUrl": category.imageUrl,
            "isActive": category.isActive,
            "timestamp": category.timestamp
        ]
        return data
    }
    
}
