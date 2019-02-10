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

  private var ingredients = [Ingredient]() {
    didSet {
      ingredients.sort { $0.name < $1.name }
      ingredientsTableView.reloadData()
    }
  }

  @IBOutlet private weak var nameTextField: UITextField!
  @IBOutlet private weak var ingredientsTableView: UITableView!
  @IBOutlet private weak var doneButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    recipe.map { setup(withRecipe: $0) }
    updateDoneButtonEnabled()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    Service.db?.ingredients(completion: { (ingredients, error) in

      if let error = error {
        print("Error fetching ingredients from DB: \(error.localizedDescription)")
      }
      ingredients.forEach {
        if !self.ingredients.contains($0) {
          self.ingredients.append($0)
        }
      }
      self.recipe.map { self.pick(ingredients: $0.ingredients) }
    })
  }

  @IBAction private func onDoneTapped(_ sender: Any) {

    guard let selectedRows = ingredientsTableView.indexPathsForSelectedRows,
      let recipeName = nameTextField.text,
      !recipeName.isEmpty
      else { return }

    let selectedIngredients = selectedRows.map { ingredients[$0.row] }
    let recipe = Recipe(id: self.recipe.map { $0.id },
                        name: recipeName,
                        ingredients: selectedIngredients)

    Service.db?.save(recipe: recipe, completion: { (error) in

      if let error = error {
        print("Unable to save recipe with error: \(error.localizedDescription)")
      } else {
        print("Succesfully saved recipe: \(recipe)")
      }
    })

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
    ingredients = recipe.ingredients
    pick(ingredients: recipe.ingredients)
  }

  private func updateDoneButtonEnabled() {

    doneButton.isEnabled = ingredientsTableView.indexPathsForSelectedRows != nil
      && !(nameTextField.text ?? "").isEmpty
  }

  private func pick(ingredients: [Ingredient]) {

    ingredients.forEach {
      if let index = self.ingredients.firstIndex(of: $0) {
        let indexPath = IndexPath(row: index, section: 0)
        ingredientsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    }
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
    cell.amountHidden = true
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
