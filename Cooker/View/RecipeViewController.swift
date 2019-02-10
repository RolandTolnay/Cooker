//
//  RecipeViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var ingredientsTableView: UITableView!

  private let ingredients = [
    Ingredient(id: "1", name: "sugar", amount: .none),
    Ingredient(id: "2", name: "flour", amount: .none),
    Ingredient(id: "3", name: "milk", amount: .none),
    ]

  var recipe: Recipe?

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
  }

  @IBAction func saveRecipe(_ sender: Any) {

    guard let selectedRows = ingredientsTableView.indexPathsForSelectedRows,
      let recipeName = nameTextField.text,
      !recipeName.isEmpty
      else { return }

    let selectedIngredients = selectedRows.map { ingredients[$0.row] }
    if var recipe = recipe {
      recipe.name = recipeName
      recipe.ingredients = selectedIngredients
      self.recipe = recipe
    } else {
      recipe = Recipe(id: "1",
                      name: recipeName,
                      ingredients: selectedIngredients,
                      url: nil,
                      photo: nil)
    }

    print("Saving recipe: \(recipe?.description ?? "N/A")")
    // Persist recipe to DB

    navigationController?.popViewController(animated: true)
  }
}

extension RecipeViewController {

  private func setupTableView() {

    ingredientsTableView.estimatedRowHeight = 75
    ingredientsTableView.rowHeight = UITableView.automaticDimension

    ingredientsTableView.tableFooterView = UIView()
    ingredientsTableView.dataSource = self
    ingredientsTableView.delegate = self

    ingredientsTableView.register(cell: IngredientCell.self)
  }
}

extension RecipeViewController: UITableViewDataSource {

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

extension RecipeViewController: UITableViewDelegate {

}
