//
//  CategoryCollectionViewCell.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-11-01.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image.layer.cornerRadius = 5
    }

    func setupCell(category: Category) {
        label.text = category.name
        if let url = URL(string: category.imageUrl) {
            image.kf.setImage(with: url)
        }
    }
        
}
