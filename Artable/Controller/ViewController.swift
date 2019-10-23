//
//  ViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-08.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginNavigationController)
        present(viewController, animated: true, completion: nil)
    }

}

