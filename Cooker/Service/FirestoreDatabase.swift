//
//  FirestoreDatabase.swift
//  Cooker
//
//  Created by Roland Tolnay on 10/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation
import Firebase

class FirestoreDatabase: Database {

  private var userId: String

  private lazy var db = Firestore.firestore()
  private lazy var userRef = db.collection("users").document(userId)
  private lazy var recipesRef = userRef.collection("recipes")
  private lazy var ingredientsRef = userRef.collection("ingredients")

  init(userId: String) {

    self.userId = userId
  }

  func recipes(completion: @escaping ([Recipe], CKError?) -> Void) {

    recipesRef.getDocuments { (snapshot, error) in

      guard let documents = snapshot?.documents else {
        completion([], error.map { CKError.databaseError(details: $0.localizedDescription) })
        return
      }

      let recipes = documents.map { Recipe(dictionary: $0.data()) }
      completion(recipes, nil)
    }
  }

  func ingredients(completion: @escaping ([Ingredient], CKError?) -> Void) {

    ingredientsRef.getDocuments { (snapshot, error) in

      guard let documents = snapshot?.documents else {
        completion([], error.map { CKError.databaseError(details: $0.localizedDescription) })
        return
      }

      let ingredients = documents.map { Ingredient(dictionary: $0.data()) }
      completion(ingredients, nil)
    }
  }

  func save(recipe: Recipe, completion: @escaping (CKError?) -> Void) {

    recipesRef.document(recipe.id).setData(recipe.asDictionary) { (error) in

      completion(error.map { CKError.databaseError(details: $0.localizedDescription) })
    }
  }

  func save(ingredient: Ingredient, completion: @escaping (CKError?) -> Void) {

    ingredientsRef.document(ingredient.id).setData(ingredient.asDictionary) { (error) in

      completion(error.map { CKError.databaseError(details: $0.localizedDescription) })
    }
  }
}
