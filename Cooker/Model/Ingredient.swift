//
//  Ingredient.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation

struct Ingredient {

  let id: String
  let name: String
  let amount: Amount

  init(id: String = "",
       name: String,
       amount: Amount = .none) {

    self.id = id
    self.name = name
    self.amount = amount
  }
}

extension Ingredient: CustomStringConvertible {

  var description: String {

    if case .none = amount {
      return "[Ingredient: \(name)]"
    } else {
      return "[Ingredient: \(name). Amount: \(amount)]"
    }
  }
}

extension Ingredient: Equatable {

  static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {

    return lhs.name == rhs.name
  }
}

enum Amount {

  case piece(amount: Int)
  case mg(amount: Int)
  case ml(amount: Int)
  case none
}

extension Amount: CustomStringConvertible {

  var description: String {

    switch self {
    case .piece(let amount):
      return "\(amount) pieces"
    case .mg(let amount):
      return "\(amount) mg"
    case .ml(let amount):
      return "\(amount) ml"
    default:
      return ""
    }
  }
}
