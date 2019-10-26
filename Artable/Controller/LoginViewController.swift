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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTextField.text, email.isNotEmpty,
            let password = passwordTextField.text, password.isNotEmpty else { return }
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                debugPrint(error)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
