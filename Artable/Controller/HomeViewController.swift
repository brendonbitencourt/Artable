//
//  ViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-08.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loginOutBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginOutBarButton.title = Auth.auth().currentUser != nil ? "Logout" : "Login"
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginNavigationController)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func loginOutClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                presentLoginController()
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            presentLoginController()
        }
    }
    
}
