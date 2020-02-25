//
//  AddEditProductViewController.swift
//  ArtableAdmin
//
//  Created by Brendon Bitencourt Braga on 2020-02-24.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit

class AddEditProductViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedCategory: Category?
    var productToEdit: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
    }

}
