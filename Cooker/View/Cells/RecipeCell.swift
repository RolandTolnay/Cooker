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
        // Initialization code
    }

  func setup(with recipe: Recipe) {

    recipeNameLabel.text = recipe.name
    ingredientsLabel.text = "\(recipe.ingredients.count) ingredients"
    photoImageView.image = recipe.photo
  }
}
