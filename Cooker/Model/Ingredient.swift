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
}

enum Amount {

  case piece(amount: Int)
  case mg(amount: Int)
  case ml(amount: Int)
  case none
}

