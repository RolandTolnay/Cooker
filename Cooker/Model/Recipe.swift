//
//  Recipe.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation
import UIKit

struct Recipe {

  let id: String
  var name: String
  var ingredients: [Ingredient]

  var url: URL?
  var photo: UIImage?

  init(id: String? = nil,
       name: String,
       ingredients: [Ingredient] = [],
       url: URL? = nil,
       photo: UIImage? = nil) {

    self.id = id ?? UUID().uuidString
    self.name = name
    self.ingredients = ingredients
    self.url = url
    self.photo = photo
  }
}

extension Recipe: CustomStringConvertible {

  var description: String {

    return "[Recipe: \(name). Ingredients: \(ingredients)]"
  }
}

extension Recipe {

  init(dictionary: [String: Any]) {

    let id = dictionary["id"] as? String ?? ""
    let name = dictionary["name"] as? String ?? ""
    assert(!name.isEmpty && !id.isEmpty)

    let ingredientsDic = dictionary["ingredients"] as? [[String: Any]] ?? []
    let ingredients = ingredientsDic.map { Ingredient(dictionary: $0) }

    self.id = id
    self.name = name
    self.ingredients = ingredients
  }

  var asDictionary: [String: Any] {

    return [
      "id": id,
      "name": name,
      "ingredients": ingredients.map { $0.asDictionary }
    ]
  }
}
