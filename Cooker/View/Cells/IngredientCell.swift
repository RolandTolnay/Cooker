//
//  IngredientCell.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {

  static var estimatedHeight: CGFloat = 93.0

  @IBOutlet private weak var ingredientNameLabel: UILabel!
  @IBOutlet private weak var amountLabel: UILabel!
  @IBOutlet private weak var amountLabelHeightConstraint: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()

    addGradient(topColor: #colorLiteral(red: 0.0862745098, green: 0.6274509804, blue: 0.5215686275, alpha: 1), bottomColor: #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1))
    backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    backgroundView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    ingredientNameLabel.textColor = .white
    amountLabel.textColor = .white
    contentView.autoresizingMask = [ .flexibleHeight ]
  }

  func setup(withIngredient ingredient: Ingredient) {

    ingredientNameLabel.text = ingredient.name
    amountLabel.text = ingredient.amount.description

    if case .none = ingredient.amount {
      amountLabelHeightConstraint.constant = 0
    } else {
      amountLabelHeightConstraint.constant = 25
    }
  }

  /// Specifies whether to hide the ingredient amount.
  /// Default is false, if ingredient amount is not equal to .none, otherwise true.
  var amountHidden: Bool {
    get {
      return amountLabelHeightConstraint.constant == 0 ? true : false
    }
    set {
      amountLabelHeightConstraint.constant = newValue ? 0 : 25
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    accessoryType = selected ? .checkmark : .none
  }
}
