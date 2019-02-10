//
//  RecipeViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

  var recipe: Recipe?

  private let ingredients = [
    Ingredient(name: "sugar"),
    Ingredient(name: "flour"),
    Ingredient(name: "milk")
  ]

  @IBOutlet private weak var nameTextField: UITextField!
  @IBOutlet private weak var ingredientsTableView: UITableView!
  @IBOutlet private weak var doneButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    recipe.map { setup(withRecipe: $0) }
    updateDoneButtonEnabled()
  }

  @IBAction private func onDoneTapped(_ sender: Any) {

    guard let selectedRows = ingredientsTableView.indexPathsForSelectedRows,
      let recipeName = nameTextField.text,
      !recipeName.isEmpty
      else { return }

    let selectedIngredients = selectedRows.map { ingredients[$0.row] }
    recipe = Recipe(name: recipeName, ingredients: selectedIngredients)

    print("Saving recipe: \(recipe?.description ?? "N/A")")
    // Persist recipe to DB

    navigationController?.popViewController(animated: true)
  }
  @IBAction func onAddIngredientTapped(_ sender: Any) {

    let ingredientViewController = IngredientViewController.instantiate()
    navigationController?.pushViewController(ingredientViewController, animated: true)
  }

  @IBAction private func onRecipeNameChanged(_ sender: Any) {

    updateDoneButtonEnabled()
  }
}

extension RecipeViewController {

  private func setupTableView() {

    ingredientsTableView.estimatedRowHeight = 83
    ingredientsTableView.rowHeight = UITableView.automaticDimension

    ingredientsTableView.tableFooterView = UIView()
    ingredientsTableView.dataSource = self
    ingredientsTableView.delegate = self

    ingredientsTableView.register(cell: IngredientCell.self)
  }

  private func setup(withRecipe recipe: Recipe) {

    nameTextField.text = recipe.name
    recipe.ingredients.forEach {
      if let index = ingredients.firstIndex(of: $0) {
        let indexPath = IndexPath(row: index, section: 0)
        ingredientsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    }
  }

  private func updateDoneButtonEnabled() {

    doneButton.isEnabled = ingredientsTableView.indexPathsForSelectedRows != nil
      && !(nameTextField.text ?? "").isEmpty
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    updateDoneButtonEnabled()
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    updateDoneButtonEnabled()
  }
}
