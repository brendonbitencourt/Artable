//
//  StripeCart.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2020-12-08.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItem = [Product]()
    var shippingFees = 0
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    
    var subtotal: Int {
        var amount = 0
        for item in cartItem {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees: Int {
        if subtotal == 0 {
            return 0
        }
        let subTotalDouble = Double(subtotal)
        let feesAndSubtotal = Int(subTotalDouble * stripeCreditCardCut) + flatFeeCents
        return feesAndSubtotal
    }
    
    var total: Int {
        return subtotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product) {
        cartItem.append(item)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItem.firstIndex(of: item) {
            cartItem.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItem.removeAll()
    }
    
}
