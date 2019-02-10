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

  override func viewDidLoad() {
    super.viewDidLoad()

    authenticate()
    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    Service.db?.recipes(completion: { (recipes, error) in

      if let error = error {
        print("Error fetching recipes from DB: \(error.localizedDescription)")
      }
      self.recipes = recipes
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
            print("Error fetching recipes from DB: \(error.localizedDescription)")
          }
          self.recipes = recipes
        })

        print("Succesfully signed in with Firebase.")
      } else {
        print("Unable to sign in with Firebase: \(error?.localizedDescription ?? "unknown error")")
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
