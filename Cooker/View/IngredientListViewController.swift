//
//  IngredientListViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class IngredientListViewController: UIViewController {

  private let ingredients = [
    Ingredient(name: "sugar", amount: .mg(amount: 500)),
    Ingredient(name: "flour", amount: .mg(amount: 300)),
    Ingredient(name: "milk", amount: .ml(amount: 500))
  ]

  @IBOutlet weak var ingredientsTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
  }
}

extension IngredientListViewController {

  private func setupTableView() {

    ingredientsTableView.estimatedRowHeight = 83
    ingredientsTableView.rowHeight = UITableView.automaticDimension

    ingredientsTableView.tableFooterView = UIView()
    ingredientsTableView.dataSource = self
    ingredientsTableView.delegate = self

    ingredientsTableView.register(cell: IngredientCell.self)
  }
}

extension IngredientListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return ingredients.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let cell = tableView.dequeueReusableCell(with: IngredientCell.self)
      else { return UITableViewCell() }

    cell.setup(withIngredient: ingredients[indexPath.row])
    cell.selectionStyle = .none

    return cell
  }
}

extension IngredientListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let ingredientViewController = IngredientViewController.instantiate()
    ingredientViewController.ingredient = ingredients[indexPath.row]
    navigationController?.pushViewController(ingredientViewController, animated: true)

    tableView.deselectRow(at: indexPath, animated: true)
  }
}

