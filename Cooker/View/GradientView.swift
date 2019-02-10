//
//  GradientView.swift
//  app-smack
//
//  Created by Roland Tolnay on 20/02/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
  
  @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.4941176471, blue: 0.1333333333, alpha: 1) {
    didSet {
      setNeedsLayout()
    }
  }
  
  @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.8274509804, green: 0.3294117647, blue: 0, alpha: 1) {
    didSet {
      setNeedsLayout()
    }
  }
  
  override func layoutSubviews() {

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.frame = self.bounds
    self.layer.insertSublayer(gradientLayer, at: 0)
  }
}
