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
      // TODO: - Make text bold
    } else {
      // Normal
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()


  }
}
