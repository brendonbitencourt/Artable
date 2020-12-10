//
//  Contants.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-23.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
}

struct StoryboardId {
    static let LoginNavigationController = "LoginNavigationController"
}

struct AppImages {
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let Placeholder = "placeholder"
}

struct AppColors {
    static let Blue = #colorLiteral(red: 0.2914361954, green: 0.3395442367, blue: 0.4364506006, alpha: 1)
    static let Red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9593321681, green: 0.9629111886, blue: 0.9751296639, alpha: 1)
}

struct Identifiers {
    static let CategoryCollectionViewCell = "CategoryCollectionViewCell"
    static let ProductCell = "ProductCell"
    static let CartItemTableViewCell = "CartItemTableViewCell"
}

struct Segues {
    static let ToProducts = "toProductsViewController"
    static let ToAddEditCategory = "toAddEditCategory"
    static let ToEditCategory = "toEditCategory"
    static let ToAddEditProduct = "toAddEditProduct"
    static let ToFavorites = "toFavorites"
}
