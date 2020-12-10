//
//  ProductsViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-11-09.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsViewController: UIViewController, ProductCellDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category?
    var listener: ListenerRegistration?
    var db: Firestore?
    var showFavoritesOnly: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        // Do any additional setup after loading the view.
        setupProductListener()
    }
    
    func setupProductListener() {
        guard let idCategory = category?.id else { return }
        var ref = db?.products(category: idCategory)
        
        if showFavoritesOnly {
            ref = db?.collection("users").document(UserService.user.id).collection("favorites")
        }
        
        listener = ref?.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                    case .added:
                        self.onDocumentAdded(change, product)
                    case .modified:
                        self.onDocumentModified(change, product)
                    case .removed:
                        self.onDocumentRemoved(change)
                    @unknown default:
                        fatalError()
                }
            })
        })
    }
    
    func productFavorited(product: Product) {
        if UserService.isGuest {
            sendMessageGuestUser()
            return
        }
        UserService.favoriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func productAddToCart(product: Product) {
        if UserService.isGuest {
            sendMessageGuestUser()
            return
        }
        StripeCart.addItemToCart(item: product)
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductTableViewCell {
            cell.setupCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        let viewController = ProductDetailViewController()
        viewController.product = selectedProduct
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true, completion: nil)
    }
    
    fileprivate func onDocumentAdded(_ change: DocumentChange, _ product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .automatic)
    }
    
    fileprivate func onDocumentModified(_ change: DocumentChange, _  product: Product) {
        let oldIndex = Int(change.oldIndex)
        let newIndex = Int(change.newIndex)
        
        if change.oldIndex == change.newIndex {
            products[oldIndex] = product
            tableView.reloadRows(at: [IndexPath(row: oldIndex, section: 0)], with: .none)
        } else {
            let oldIndexPath = IndexPath(item: oldIndex, section: 0)
            let newIndexPath = IndexPath(item: newIndex, section: 0)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        }
    }
    
    fileprivate func onDocumentRemoved(_ change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .automatic)
    }
    
}
