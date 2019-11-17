//
//  ProductTableViewCell.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-11-09.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(product: Product) {
        titleLabel.text = product.name
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
    }
    
    @IBAction func addToCardClicked(_ sender: Any) {
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
}
