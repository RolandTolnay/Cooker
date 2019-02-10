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

  private let recipes = [
    Recipe(name: "Tuna salad", ingredients: [Ingredient(name: "sugar")]),
    Recipe(name: "Quinoa salad"),
    Recipe(name: "Chicken pasta"),
    Recipe(name: "Very long recipe name to test automatic cell resizing dimensions")
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    authenticate()
    setupTableView()
  }
}

extension RecipeListViewController {

  private func authenticate() {

    Auth.auth().signInAnonymously { (result, error) in

      if let error = error {
        print("Unable to sign in with Firebase: \(error.localizedDescription)")
      } else {
        print("Succesfully signed in with Firebase.")
      }
    }
  }

  private func setupTableView() {

    recipesTableView.estimatedRowHeight = 85
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

    cell.setup(with: recipes[indexPath.row])

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
}
