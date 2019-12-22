//
//  AddEditCategoryViewController.swift
//  ArtableAdmin
//
//  Created by Brendon Bitencourt Braga on 2019-12-21.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit

class AddEditCategoryViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImage.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        launchImagePicker()
    }

    @IBAction func addCategoryClicked(_ sender: Any) {
        
    }
    
}

extension AddEditCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        activityIndicator.startAnimating()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true) {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
