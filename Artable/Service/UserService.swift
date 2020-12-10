//
//  UserService.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2020-08-22.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
    
    var user = User()
    var favorites = [Product]()
    var auth = Auth.auth()
    var db = Firestore.firestore()
    var userListener: ListenerRegistration? = nil
    var favoritesListener: ListenerRegistration? = nil
    
    var isGuest: Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        }
        return false
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
        })
        
        let favoritesRef = userRef.collection("favorites")
        favoritesListener = favoritesRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func favoriteSelected(product: Product) {
        let favoritesRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        if favorites.contains(product) {
            favorites.removeAll { $0 == product }
            favoritesRef.document(product.id).delete()
        } else {
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favoritesRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser () {
        self.userListener?.remove()
        self.userListener = nil
        self.favoritesListener?.remove()
        self.favoritesListener = nil
        self.user = User()
        favorites.removeAll()
    }
}
