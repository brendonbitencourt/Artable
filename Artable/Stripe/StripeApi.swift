//
//  StripeApi.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2020-12-09.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let data = [
            "stripe_version": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil, error)
            }
            
            guard let key = result?.data as? [String: Any] else {
                completion(nil, error)
                return
            }
            
            completion(key, nil)
        }
    }
    
}
