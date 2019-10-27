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
    
    func handleFireAuthError(error: Error) {
        guard let errorCode = AuthErrorCode(rawValue: error._code) else { return }
        let alert = UIAlertController(title: "Error", message: errorCode.message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension AuthErrorCode {
    var message: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
        default:
            return "Sorry, something went wrong."
        }
    }
}
