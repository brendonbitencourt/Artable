//
//  ForgotPasswordViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-27.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordClicked(_ sender: Any) {
        guard let email = self.emailTextField.text, email.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please fill out all fields.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                Auth.auth().handleError(error: error, viewController: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
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
