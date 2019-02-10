//
//  IngredientCell.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {

  @IBOutlet private weak var ingredientNameLabel: UILabel!
  @IBOutlet private weak var amountLabel: UILabel!
  @IBOutlet private weak var amountLabelHeightConstraint: NSLayoutConstraint!

  func setup(withIngredient ingredient: Ingredient) {

    ingredientNameLabel.text = ingredient.name
    amountLabel.text = ingredient.amount.description

    if case .none = ingredient.amount {
      amountLabelHeightConstraint.constant = 0
    } else {
      amountLabelHeightConstraint.constant = 25
    }
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      accessoryType = selected ? .checkmark : .none
    }

}
