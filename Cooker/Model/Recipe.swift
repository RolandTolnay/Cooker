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
  let name: String
  let ingredients: [Ingredient]

  let url: URL?
  let photo: UIImage?
}
