//
//  RecipeListViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit
import Firebase

class RecipeListViewController: UIViewController {

  @IBOutlet private weak var recipesTableView: UITableView!

  private var recipes = [Recipe]() {
    didSet {
      recipesTableView.reloadData()
    }
  }
  private var ingredientStock = [Ingredient]() {
    didSet {
      recipesTableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    authenticate()
    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    Service.db?.recipes(completion: { (recipes, error) in

      if let error = error {
        log.error("Error fetching recipes from DB: \(error.localizedDescription)")
      }
      self.recipes = recipes
    })
    Service.db?.ingredients(completion: { (ingredients, error) in

      if let error = error {
        log.error("Error fetching ingredients from DB: \(error.localizedDescription)")
      }
      self.ingredientStock = ingredients
    })
  }
}

extension RecipeListViewController {

  private func authenticate() {

    Auth.auth().signInAnonymously { (result, error) in

      if let result = result {

        let db = FirestoreDatabase(userId: result.user.uid)
        Service.db = db
        db.recipes(completion: { (recipes, error) in

          if let error = error {
            log.error("Error fetching recipes from DB: \(error.localizedDescription)")
          }
          self.recipes = recipes
        })
        db.ingredients(completion: { (ingredients, error) in

          if let error = error {
            log.error("Error fetching ingredients from DB: \(error.localizedDescription)")
          }
          self.ingredientStock = ingredients
        })

        log.info("Succesfully signed in with Firebase.")
      } else {
        log.error("Unable to sign in with Firebase: \(error?.localizedDescription ?? "unknown error")")
      }
    }
  }

  private func setupTableView() {

    recipesTableView.estimatedRowHeight = 97
    recipesTableView.rowHeight = UITableView.automaticDimension

    recipesTableView.tableFooterView = UIView()
    recipesTableView.dataSource = self
    recipesTableView.delegate = self
  }
}

extension RecipeListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return recipes.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let cell = tableView.dequeueReusableCell(with: RecipeCell.self)
      else { return UITableViewCell() }

    let recipe = recipes[indexPath.row]
    let stockCount = ingredientStock.filter { recipe.ingredients.contains($0) && $0.amount != .none }.count
    cell.setup(with: recipe, stockCount: stockCount)

    return cell
  }
}

extension RecipeListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let recipeViewController = RecipeViewController.instantiate()
    recipeViewController.recipe = recipes[indexPath.row]
    navigationController?.pushViewController(recipeViewController, animated: true)

    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    if (editingStyle == .delete) {
      
      let recipe = recipes[indexPath.row]
      Service.db?.delete(recipe: recipe, completion: { (error) in

        if let error = error {
          log.error("Failed deleting \(recipe) with error: \(error.localizedDescription)")
        } else {
          log.debug("Succesfully deleted \(recipe).")
        }
      })
      recipes = recipes.filter { $0.id != recipe.id }
    }
  }
}
