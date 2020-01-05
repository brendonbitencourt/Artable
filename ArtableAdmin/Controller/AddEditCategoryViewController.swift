//
//  AddEditCategoryViewController.swift
//  ArtableAdmin
//
//  Created by Brendon Bitencourt Braga on 2019-12-21.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

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
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        activityIndicator.startAnimating()
        
        guard let image = categoryImage.image, let categoryName = nameTextField.text else {
            self.handleError(nil, message: "Unable to create category")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("categoryImage/\(categoryName).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error, message: "Unable to create category")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                   self.handleError(error, message: "Unable to create category")
                    return
                }
                guard let url = url else { return }
                self.uploadDocument(url: url.absoluteString)
            }
        }
        
    }
    
    func uploadDocument(url: String) {
        guard let categoryName = nameTextField.text else { return }
        let documentRef = Firestore.firestore().collection("categories").document()
        let category = Category.init(name: categoryName, id: documentRef.documentID, imageUrl: url, timestamp: Timestamp())
        let data = Category.modelToData(category: category)
        
        documentRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error, message: "Unable to create category")
                return
            }
            self.activityIndicator.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(_ error: Error?, message: String) {
        simpleAlert(title: "Error", message: message)
        activityIndicator.stopAnimating()
        if let error = error { debugPrint(error.localizedDescription) }
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
