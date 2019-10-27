//
//  Extentions.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-13.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Firebase

extension String {
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
}

extension UIViewController {

    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
