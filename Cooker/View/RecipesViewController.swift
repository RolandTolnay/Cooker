//
//  RecipesViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit
import Firebase

class RecipesViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    Auth.auth().signInAnonymously { (result, error) in

      if let error = error {
        print("Unable to sign in with Firebase: \(error.localizedDescription)")
      } else {
        print("Succesfully signed in with Firebase.")
      }
    }
  }
}
