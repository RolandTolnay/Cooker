//
//  RecipeCell.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

  @IBOutlet private weak var recipeNameLabel: UILabel!
  @IBOutlet private weak var ingredientsLabel: UILabel!
  @IBOutlet private weak var photoImageView: UIImageView!

  func setup(with recipe: Recipe, stockCount: Int) {

    recipeNameLabel.text = recipe.name
    ingredientsLabel.text = "\(stockCount)/\(recipe.ingredients.count) ingredients in stock"
    photoImageView.image = recipe.photo

    if stockCount == recipe.ingredients.count {
      ingredientsLabel.textColor = #colorLiteral(red: 0.0862745098, green: 0.6274509804, blue: 0.5215686275, alpha: 1)
    } else {
      ingredientsLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
  }
}
