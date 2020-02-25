//
//  AddEditProductViewController.swift
//  ArtableAdmin
//
//  Created by Brendon Bitencourt Braga on 2020-02-24.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addProductButton: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedCategory: Category?
    var productToEdit: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        productImage.addGestureRecognizer(tap)
        // If we are editing, productToEdit will not be nil
        if let productToEdit = productToEdit {
            setupEdit(productToEdit)
        }
    }
    
    func setupEdit(_ productToEdit: Product) {
        nameTextField.text = productToEdit.name
        priceTextField.text = String(productToEdit.price)
        descriptionTextView.text = productToEdit.desc
        addProductButton.setTitle("Save Changes", for: .normal)
        if let url = URL(string: productToEdit.imageUrl) {
            productImage.contentMode = .scaleAspectFill
            productImage.kf.setImage(with: url)
        }
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    @IBAction func addProductClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        activityIndicator.startAnimating()
        
        guard
            let image = productImage.image,
            let name = nameTextField.text, name.isNotEmpty,
            let description = descriptionTextView.text, description.isNotEmpty,
            let priceString = priceTextField.text, priceString.isNotEmpty,
            let price = Double(priceString),
            let category = selectedCategory, category.id.isNotEmpty
            else {
                self.handleError(nil, message: "Unable to create product")
                return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("productImages/\(name).jpg")
        
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
                self.uploadDocument(url: url.absoluteString, name, category.id, price, description)
            }
        }
        
    }
    
    func uploadDocument(url: String, _ name: String, _ categoryID: String, _ price: Double, _ desc: String) {
        var documentRef: DocumentReference!
        
        if let productToEdit = productToEdit {
            documentRef = Firestore.firestore().collection("products").document(productToEdit.id)
        } else {
            documentRef = Firestore.firestore().collection("products").document()
        }
        
        let product = Product.init(name: name, id: documentRef.documentID, category: categoryID, price: price, desc: desc, imageUrl: url)
        let data = Product.modelToData(product: product)
        
        documentRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error, message: "Unable to create product")
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

extension AddEditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        productImage.contentMode = .scaleAspectFill
        productImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
