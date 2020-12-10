//
//  ProductDetailViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-12-01.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    
    //Variables
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        productTitle.text = product?.name
        productDescription.text = product?.desc
        
        if let imageUrl = product?.imageUrl {
            let url = URL(string: imageUrl)
            productImage.kf.setImage(with: url)
        }
        
        if let priceNumber = product?.price {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            if let price = formatter.string(from: priceNumber as NSNumber) {
                productPrice.text = price
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCartClicked(_ sender: Any) {
        if UserService.isGuest {
            sendMessageGuestUser()
            return
        }
        if let product = self.product {
            StripeCart.addItemToCart(item: product)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
