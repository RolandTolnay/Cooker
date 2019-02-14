//
//  IngredientListViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class IngredientListViewController: UIViewController {

  private var ingredients = [Ingredient]() {
    didSet {
      ingredients.sort { $0 > $1 }
      ingredientsTableView.reloadData()
    }
  }

  @IBOutlet private weak var ingredientsTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    loadIngredients()
  }

  @IBAction private func onAddIngredientTapped(_ sender: Any) {

    presentAddIngredientScreen()
  }
}

extension IngredientListViewController {

  private func setupTableView() {

    ingredientsTableView.estimatedRowHeight = IngredientCell.estimatedHeight
    ingredientsTableView.rowHeight = UITableView.automaticDimension

    ingredientsTableView.tableFooterView = UIView()
    ingredientsTableView.dataSource = self
    ingredientsTableView.delegate = self

    ingredientsTableView.register(cell: IngredientCell.self)
  }

  private func loadIngredients() {

    Service.db?.ingredients(completion: { (ingredients, error) in

      if let error = error {
        log.error("Error fetching ingredients from DB: \(error.localizedDescription)")
      }
      self.ingredients = ingredients
    })
  }

  private func presentAddIngredientScreen(with ingredient: Ingredient? = nil) {

    let ingredientVC = IngredientViewController.instantiate()
    ingredientVC.ingredient = ingredient
    ingredientVC.existingIngredients = ingredients.filter { $0 != ingredient }
    ingredientVC.onIngredientAdded = { [weak self] ingredient in

      guard let welf = self else { return }
      if let index = welf.ingredients.index(of: ingredient) {
        welf.ingredients[index].amount = ingredient.amount
        DispatchQueue.main.async {
          welf.ingredientsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
      } else {
        welf.ingredients.append(ingredient)
      }
    }
    present(ingredientVC, animated: true, completion: nil)
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

    presentAddIngredientScreen(with: ingredients[indexPath.row])
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    if (editingStyle == .delete) {

      let ingredient = ingredients[indexPath.row]
      Service.db?.delete(ingredient: ingredient, completion: { (error) in

        if let error = error {
          log.error("Failed deleting \(ingredient) with error: \(error.localizedDescription)")
        } else {
          log.debug("Succesfully deleted \(ingredient).")
        }
      })
      ingredients = ingredients.filter { $0.id != ingredient.id }
    }
  }
}

