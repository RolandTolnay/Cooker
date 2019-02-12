//
//  Amount.swift
//  Cooker
//
//  Created by Roland Tolnay on 10/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation

enum Amount: Hashable {

  case piece(amount: Int)
  case gramms(amount: Int)
  case millilitres(amount: Int)
  case none

  var title: String? {

    switch self {
    case .piece:
      return "pieces"
    case .gramms:
      return "gramms"
    case .millilitres:
      return "millilitres"
    default:
      return nil
    }
  }

  var value: Int? {

    get {

      switch self {
      case .piece(let amount),
           .gramms(let amount),
           .millilitres(let amount):
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
      case .gramms:
        self = .gramms(amount: value)
      case .millilitres:
        self = .millilitres(amount: value)
      default:
        assertionFailure("Attempting to set amount value for .none")
        return
      }
    }
  }

  static var selectableCases: [Amount] {
    return [.piece(amount: 0), .gramms(amount: 0), .millilitres(amount: 0)]
  }
}

extension Amount: Equatable {

  static func == (lhs: Amount, rhs: Amount) -> Bool {

    switch (lhs, rhs) {
    case (.piece, .piece),
         (.gramms, .gramms),
         (.millilitres, .millilitres),
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
    case .gramms(let amount):
      return "\(amount) gramms"
    case .millilitres(let amount):
      return "\(amount) millilitres"
    default:
      return ""
    }
  }
}

extension Amount {

  init(type: String, amount: Int) {

    switch type {
    case "pieces":
      self = .piece(amount: amount)
    case "gramms":
      self = .gramms(amount: amount)
    case "millilitres":
      self = .millilitres(amount: amount)
    default:
      self = .none
    }
  }

  var abbreviation: String {

    switch self {
    case .piece:
      return "pcs"
    case .gramms:
      return "g"
    case .millilitres:
      return "ml"
    default:
      return ""
    }
  }
}
