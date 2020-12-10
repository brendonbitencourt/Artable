//
//  User.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2020-08-22.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    var stripeId: String
    
    init(id: String = "", email: String = "", username: String = "", stripedId: String = "") {
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripedId
    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stripeId = data["stripeId"] as? String ?? ""
    }
    
    static func modelToData(user: User) -> [String: Any] {
        let data: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "stripeId": user.stripeId
        ]
        return data
    }
}
