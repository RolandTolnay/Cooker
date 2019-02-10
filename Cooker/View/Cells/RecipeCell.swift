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

  override func awakeFromNib() {
    super.awakeFromNib()

    addGradient(topColor: #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1), bottomColor: #colorLiteral(red: 0.9529411765, green: 0.6117647059, blue: 0.07058823529, alpha: 1))
    recipeNameLabel.textColor = .white
    ingredientsLabel.textColor = .white
  }

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
