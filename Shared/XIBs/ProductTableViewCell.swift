//
//  ProductTableViewCell.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-11-09.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: AnyObject {
    func productFavorited(product: Product)
    func productAddToCart(product: Product)
}

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: ProductCellDelegate?
    private var product: Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        
        titleLabel.text = product.name
        
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: AppImages.Placeholder)
            let options: KingfisherOptionsInfo = [.transition(.fade(0.1))]
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
         
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            priceLabel.text = price
        }
        
        if UserService.favorites.contains(product) {
            favoriteButton.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
    }
    
    @IBAction func addToCardClicked(_ sender: Any) {
        guard let product = self.product else { return }
        self.delegate?.productAddToCart(product: product)
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        guard let product = self.product else { return }
        self.delegate?.productFavorited(product: product)
    }
    
}
