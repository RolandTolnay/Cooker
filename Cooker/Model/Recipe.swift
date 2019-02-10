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
  
  init(id: String = "",
       name: String,
       ingredients: [Ingredient] = [],
       url: URL? = nil,
       photo: UIImage? = nil) {
    
    self.id = id
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
