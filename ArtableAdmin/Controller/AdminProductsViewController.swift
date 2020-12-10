//
//  AdminProductsViewController.swift
//  ArtableAdmin
//
//  Created by Brendon Bitencourt Braga on 2020-02-24.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit

class AdminProductsViewController: ProductsViewController {
    
    var selectedProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategoryAction))
        let newProductButton = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProductAction))
        navigationItem.setRightBarButtonItems([editCategoryButton, newProductButton], animated: false)
    }
    
    @objc func editCategoryAction() {
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
    
    @objc func newProductAction() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Editing Product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductViewController {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryViewController {
                destination.categoryToEdit = category
            }
        }
    }
    
    override func productFavorited(product: Product) {
        return
    }
    
    override func productAddToCart(product: Product) {
        return
    }
}
