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

  @IBOutlet weak var ingredientsTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    Service.db?.ingredients(completion: { (ingredients, error) in

      if let error = error {
        print("Error fetching ingredients from DB: \(error.localizedDescription)")
      }
      self.ingredients = ingredients
    })
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

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    if (editingStyle == .delete) {

      let ingredient = ingredients[indexPath.row]
      Service.db?.delete(ingredient: ingredient, completion: { (error) in

        if let error = error {
          print("Failed deleting \(ingredient) with error: \(error.localizedDescription)")
        } else {
          print("Succesfully deleted \(ingredient).")
        }
      })
      ingredients = ingredients.filter { $0.id != ingredient.id }
    }
  }
}

