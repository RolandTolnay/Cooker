//
//  UIColor+Common.swift
//  SmartHome
//
//  Created by Zoltan Ulrich on 20/07/2018.
//

import Foundation
import UIKit

extension UIColor {

  func withOpacity(_ opacity: CGFloat) -> UIColor {

    let alpha = opacity.clamped(to: 0...1)
    return alterColor(deltaBrightness: 0, resultAlpha: alpha)
  }

  var luminance: CGFloat {
    // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests

    let ciColor = CIColor(color: self)

    func adjust(colorComponent: CGFloat) -> CGFloat {
      return (colorComponent < 0.03928) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
    }

    return 0.2126 * adjust(colorComponent: ciColor.red) +
           0.7152 * adjust(colorComponent: ciColor.green) +
           0.0722 * adjust(colorComponent: ciColor.blue)
  }

  convenience init(hue: CGFloat, saturation: CGFloat) {

    self.init(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
  }

  var darkerColor: UIColor {
    return alterColor(deltaBrightness: -0.1, resultAlpha: -1)
  }

  var lighterColor: UIColor {
    return alterColor(deltaBrightness: +0.1, resultAlpha: -1)
  }

  private func alterColor(deltaBrightness val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0
    var b: CGFloat = 0, a: CGFloat = 0

    guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return self }

    return UIColor(hue: h,
                   saturation: s,
                   brightness: min(1, max(b + val, 0.0)),
                   alpha: alpha == -1 ? a : alpha)
  }
}

// https://github.com/MobileToolkit/UIKitExtensions/blob/master/Sources/UIColor%2BEquatable.swift
public func == (lhs: UIColor, rhs: UIColor) -> Bool {
  let tolerance: CGFloat = 0.01

  var lhsR: CGFloat = 0
  var lhsG: CGFloat = 0
  var lhsB: CGFloat = 0
  var lhsA: CGFloat = 0
  var rhsR: CGFloat = 0
  var rhsG: CGFloat = 0
  var rhsB: CGFloat = 0
  var rhsA: CGFloat = 0

  lhs.getRed(&lhsR, green: &lhsG, blue: &lhsB, alpha: &lhsA)
  rhs.getRed(&rhsR, green: &rhsG, blue: &rhsB, alpha: &rhsA)

  let redDiff = fabs(lhsR - rhsR)
  let greenDiff = fabs(lhsG - rhsG)
  let blueDiff = fabs(lhsB - rhsB)
  let alphaDiff = fabs(lhsA - rhsA)

  return redDiff < tolerance && greenDiff < tolerance && blueDiff < tolerance && alphaDiff < tolerance
}
