//
//  Extensions.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITableView
extension UITableView {

  func register<T>(cell: T.Type) where T: UITableViewCell {

    let nib = UINib(nibName: "\(cell.self)", bundle: Bundle(for: T.self))
    register(nib, forCellReuseIdentifier: cell.identifier)
  }

  func dequeueReusableCell<T: UITableViewCell>(with cell: T.Type) -> T? {

    return dequeueReusableCell(withIdentifier: cell.identifier) as? T
  }

  /// Hides the bottom separator for the last cell in the tableview
  func makeFooterEmpty() {

    tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 1))
  }

  func hideError() {

    backgroundView = nil
  }

  func displayMessage(_ message: String) {

    let messageLabel = UILabel(frame: CGRect(origin: .zero,
                                             size: CGSize(width: bounds.width,
                                                          height: bounds.height)))
    messageLabel.text = message
    messageLabel.textAlignment = .center

    backgroundView = messageLabel
  }
}

extension UITableViewCell {

  fileprivate static var identifier: String {

    return "\(self)"
  }
}

// MARK: - UIView
extension UIView {

  func addGradient(topColor: UIColor, bottomColor: UIColor) {

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    gradientLayer.frame = self.bounds
    self.layer.insertSublayer(gradientLayer, at: 0)
  }

  @IBInspectable var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }

  @IBInspectable var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }

  @IBInspectable var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }

  @IBInspectable var shadowColor: UIColor? {
    get {
      if let cgColor = layer.shadowColor {
        return UIColor(cgColor: cgColor)
      } else {
        return nil
      }
    }
    set {
      layer.shadowColor = newValue?.cgColor
    }
  }
}

// MARK: - UIViewController
extension UIViewController {

  static var storyboard: UIStoryboard {

    return UIStoryboard(name: "Main", bundle: Bundle(for: self))
  }

  class func instantiate() -> Self {

    return viewController(viewControllerClass: self)
  }

  private static func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {

    guard let scene = storyboard.instantiateViewController(withIdentifier: "\(self)") as? T
      else { fatalError("Could not find storyboard named: \(self) with initial view controller set.") }

    return scene
  }

  func hideKeyboardWhenTappedArround() {

    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {

    view.endEditing(true)
  }

  func displayAlert(withMessage message: String, handler: ((_ action: UIAlertAction) -> Void)? = nil) {

    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .cancel,
                                  handler: handler))
    self.present(alert, animated: true)
  }

  var isPresentedModally: Bool {

    return presentingViewController != nil ||
      navigationController?.presentingViewController?.presentedViewController === navigationController ||
      tabBarController?.presentingViewController is UITabBarController
  }

  func dismissOrPop() {

    if isPresentedModally {
      dismiss(animated: true, completion: nil)
    } else {
      navigationController?.popViewController(animated: true)
    }
  }
}

// MARK: - UITextField
extension UITextField {

  func addPaddingLeft(_ padding: CGFloat) {

    let paddingView = UIView(frame:
      CGRect(x: 0, y: 0, width: padding, height: frame.height)
    )
    leftView = paddingView
    leftViewMode = .always
  }
}
