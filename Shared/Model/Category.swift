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
    var isActive: Bool = true
    var timestamp: Timestamp
    
}
