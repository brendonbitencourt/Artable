//
//  CartItemTableViewCell.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2020-12-08.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit

protocol CartItemDelegate: AnyObject {
    func removeProduct(product: Product)
}

class CartItemTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    // Variables
    private var product: Product?
    weak var delegate: CartItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(product: Product, delegate: CartItemDelegate) {
        self.product = product
        self.delegate = delegate
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLabel.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        guard let product = self.product else { return }
        self.delegate?.removeProduct(product: product)
    }
    
}
