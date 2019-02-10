//
//  Ingredient.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation

struct Ingredient: Hashable {

  let id: String
  var name: String
  var amount: Amount

  init(id: String? = nil,
       name: String,
       amount: Amount = .none) {

    self.id = id ?? UUID().uuidString
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

extension Ingredient: Comparable {

  static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {

    switch (lhs.amount, rhs.amount) {
    case (.none, .piece),
         (.none, .gramms),
         (.none, .millilitres):
      return true
    case (.piece, .none),
         (.gramms, .none),
         (.millilitres, .none):
      return false
    case (.piece(let lhsAmount), .piece(let rhsAmount)),
         (.gramms(let lhsAmount), .gramms(let rhsAmount)),
         (.millilitres(let lhsAmount), .millilitres(let rhsAmount)):
      return lhsAmount > rhsAmount
    default:
      return lhs.name < rhs.name
    }
  }
}

extension Ingredient {

  init(dictionary: [String: Any]) {

    let id = dictionary["id"] as? String ?? ""
    let name = dictionary["name"] as? String ?? ""
    assert(!name.isEmpty && !id.isEmpty)

    let amountValue = dictionary["amountValue"] as? Int ?? 0
    let amountType = dictionary["amountType"] as? String ?? ""
    let amount = Amount(type: amountType, amount: amountValue)

    self.id = id
    self.name = name
    self.amount = amount
  }

  var asDictionary: [String: Any] {

    return [
      "id": id,
      "name": name,
      "amountValue": amount.value ?? 0,
      "amountType": amount.title ?? ""
    ]
  }
}
