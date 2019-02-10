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
  var name: String
  var amount: Amount

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

  var title: String? {

    switch self {
    case .piece:
      return "pieces"
    case .mg:
      return "mg"
    case .ml:
      return "ml"
    default:
      return nil
    }
  }

  var value: Int? {

    get {

      switch self {
      case .piece(let amount),
           .mg(let amount),
           .ml(let amount):
        return amount
      default:
        return nil
      }
    }
    set {

      guard let value = newValue else { return }
      switch self {
      case .piece:
        self = .piece(amount: value)
      case .mg:
        self = .mg(amount: value)
      case .ml:
        self = .ml(amount: value)
      default:
        assertionFailure("Attempting to set amount value for .none")
        return
      }
    }
  }

  static var selectableCases: [Amount] {
    return [.piece(amount: 0), .mg(amount: 0), .ml(amount: 0)]
  }
}

extension Amount: Equatable {

  static func == (lhs: Amount, rhs: Amount) -> Bool {

    switch (lhs, rhs) {
    case (.piece, .piece),
         (.mg, .mg),
         (.ml, .ml),
         (.none, .none):
      return true
    default:
      return false
    }
  }
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
