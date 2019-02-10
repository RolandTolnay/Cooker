//
//  CKError.swift
//  Cooker
//
//  Created by Roland Tolnay on 10/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation

enum CKError: Error {

  case databaseError(details: String)
  case authError(details: String)
}
