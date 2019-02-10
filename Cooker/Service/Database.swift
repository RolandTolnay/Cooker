//
//  Database.swift
//  Cooker
//
//  Created by Roland Tolnay on 10/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation

protocol Database: class {
  
  func recipes(completion: @escaping ([Recipe], CKError?) -> Void)
  
  func ingredients(completion: @escaping ([Ingredient], CKError?) -> Void)
  
  func save(recipe: Recipe, completion: @escaping (CKError?) -> Void)
  
  func save(ingredient: Ingredient, completion: @escaping (CKError?) -> Void)
}
