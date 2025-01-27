//
//  RegisterViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-13.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    //MARK - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordCheck: UIImageView!
    @IBOutlet weak var confirmPasswordCheck: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passwordText = passwordTextField.text else { return }
        
        if textField == confirmPasswordTextfield {
            passwordCheck.isHidden = false
            confirmPasswordCheck.isHidden = false
        } else {
            if passwordText.isEmpty {
                passwordCheck.isHidden = true
                confirmPasswordCheck.isHidden = true
                confirmPasswordTextfield.text = ""
            }
        }
        
        if passwordTextField.text == confirmPasswordTextfield.text {
            passwordCheck.tintColor = UIColor.systemGreen
            confirmPasswordCheck.tintColor = UIColor.systemGreen
        } else {
            passwordCheck.tintColor = UIColor.systemRed
            confirmPasswordCheck.tintColor = UIColor.systemRed
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        guard let name = self.nameTextField.text, name.isNotEmpty,
            let password = self.passwordTextField.text, password.isNotEmpty,
            let email = self.emailTextField.text, email.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please fill out all fields.")
                return
        }
        
        guard let confirmPassword = self.confirmPasswordTextfield.text, confirmPassword == password else {
            simpleAlert(title: "Error", message: "Password do not match.")
            return
        }
        
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                Auth.auth().handleError(error: error, viewController: self)
//                return
//            }
//
//            guard let firUser = result?.user else { return }
//            let artUser = User(id: firUser.uid, email: email, username: name, stripedId: "")
//            self.createFirestoreUser(user: artUser)
//        }
        
        guard let authUser = Auth.auth().currentUser else { return }
        
        activityIndicator.startAnimating()
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                Auth.auth().handleError(error: error, viewController: self)
                return
            }
            
            guard let firUser = result?.user else { return }
            let artUser = User(id: firUser.uid, email: email, username: name, stripedId: "")
            self.createFirestoreUser(user: artUser)
        }
    }
    
    
    fileprivate func createFirestoreUser(user: User) {
        let newUserRed = Firestore.firestore().collection("users").document(user.id)
        let data = User.modelToData(user: user)
        newUserRed.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleError(error: error, viewController: self)
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
