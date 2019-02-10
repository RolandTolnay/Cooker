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

  @IBOutlet weak var recipesTableView: UITableView!

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

    recipesTableView.tableFooterView = UIView()
    recipesTableView.dataSource = self
    recipesTableView.delegate = self
  }
}

extension RecipeListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    // TODO: -
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    // TODO: -
    return UITableViewCell()
  }


}

extension RecipeListViewController: UITableViewDelegate {

}
