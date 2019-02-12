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

  private var ingredients = [Ingredient]()

  @IBOutlet private weak var nameTextField: UITextField!
  @IBOutlet private weak var ingredientsTableView: UITableView!
  @IBOutlet private weak var saveButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    nameTextField.addPaddingLeft(10.0)
    hideKeyboardWhenTappedArround()

    if !isPresentedModally {
      navigationItem.leftBarButtonItem = nil
      navigationItem.hidesBackButton = false
    }

    recipe.map { setup(withRecipe: $0) }
    loadIngredients()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if (nameTextField.text ?? "").isEmpty {
      nameTextField.becomeFirstResponder()
    }
  }

  @IBAction private func onSaveTapped(_ sender: Any) {

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

    dismissOrPop()
  }

  @IBAction private func onCancelTapped(_ sender: Any) {

    dismissOrPop()
  }

  @IBAction private func onRecipeNameChanged(_ sender: Any) {

    updateSaveButtonEnabled()
  }

  @IBAction private func onRecipeNameReturn(_ sender: Any) {

    view.endEditing(true)
  }

  @IBAction private func onAddIngredientTapped(_ sender: Any) {

    let addIngredientVC = IngredientViewController.instantiate()
    addIngredientVC.existingIngredients = ingredients
    addIngredientVC.onIngredientAdded = { [weak self] ingredient in

      guard let welf = self else { return }
      let indexPath = IndexPath(row: 0, section: 0)
      welf.ingredients.insert(ingredient, at: indexPath.row)
      welf.ingredientsTableView.insertRows(at: [indexPath], with: .top)
      welf.ingredientsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
      welf.updateSaveButtonEnabled()
    }
    present(addIngredientVC, animated: true, completion: nil)
  }
}

extension RecipeViewController {

  private func setupTableView() {

    ingredientsTableView.estimatedRowHeight = IngredientCell.estimatedHeight
    ingredientsTableView.rowHeight = UITableView.automaticDimension

    ingredientsTableView.tableFooterView = UIView()
    ingredientsTableView.dataSource = self
    ingredientsTableView.delegate = self

    ingredientsTableView.register(cell: IngredientCell.self)
  }

  private func setup(withRecipe recipe: Recipe) {

    nameTextField.text = recipe.name
    ingredients = recipe.ingredients
    ingredientsTableView.reloadData()
    pick(ingredients: recipe.ingredients)
  }

  private func updateSaveButtonEnabled() {

    saveButton.isEnabled = ingredientsTableView.indexPathsForSelectedRows != nil
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

  private func loadIngredients() {

    Service.db?.ingredients(completion: { (ingredients, error) in

      if let error = error {
        print("Error fetching ingredients from DB: \(error.localizedDescription)")
      }
      self.ingredients.append(contentsOf:
        ingredients
          .filter { !self.ingredients.contains($0) }
          .sorted { $0.name < $1.name }
      )
      DispatchQueue.main.async {
        self.ingredientsTableView.reloadData()
        self.recipe.map { self.pick(ingredients: $0.ingredients) }
      }
    })
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
    cell.tintColor = #colorLiteral(red: 0.9019607843, green: 0.4941176471, blue: 0.1333333333, alpha: 1)
    cell.selectionStyle = .none

    return cell
  }
}

extension RecipeViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    updateSaveButtonEnabled()
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    updateSaveButtonEnabled()
  }
}
