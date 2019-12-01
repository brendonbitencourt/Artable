//
//  LoginViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-13.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup a fter loading the view.
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        let viewController = ForgotPasswordViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTextField.text, email.isNotEmpty,
            let password = passwordTextField.text, password.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please fill out all fields.")
                return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                Auth.auth().handleError(error: error, viewController: self)
                return
            }
            self.dismiss(animated: true) {
                if let presentationController = self.presentationController {
                    self.presentationController?.delegate?.presentationControllerDidDismiss?(presentationController)
                }
            }
        }
    }
    
    @IBAction func guestClicked(_ sender: Any) {
    }

}
