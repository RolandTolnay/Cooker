//
//  IngredientViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController {
  
  var existingIngredients = [Ingredient]()
  var ingredient: Ingredient?
  var onIngredientAdded: ((Ingredient) -> Void)?
  
  @IBOutlet private weak var nameTextField: UITextField!
  @IBOutlet private weak var amountTextField: UITextField!
  @IBOutlet private weak var amountSlider: UISlider!
  @IBOutlet private weak var amountSegmentedControl: UISegmentedControl!
  @IBOutlet private weak var amountLabel: UILabel!
  @IBOutlet private weak var saveButton: UIButton!
  @IBOutlet private weak var opaqueView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTextFields()
    amountSegmentedControl.selectedSegmentIndex = -1
    amountLabel.text = amountSegmentedControl.measurementLabel
    ingredient.map { setup(withIngredient: $0) }
    updateAmountSliderHidden()
    
    if !isPresentedModally {
      navigationItem.leftBarButtonItem = nil
      navigationItem.hidesBackButton = false
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    nameTextField.becomeFirstResponder()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.3) {
      self.view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withOpacity(0.6)
    }
  }
  
  @IBAction private func onSaveTapped(_ sender: Any) {
    
    saveIngredientAndDismiss()
  }
  
  @IBAction private func onCancelTapped(_ sender: Any) {
    
    dismissOrPop()
  }
  
  @IBAction private func onIngredientNameChanged(_ sender: Any) {
    
    updateSaveButtonEnabled()
  }
  
  @IBAction private func onAmountChanged(_ sender: Any) {
    
    updateSaveButtonEnabled()
    let amountValue = Float(amountTextField.text ?? "") ?? 0
    amountSlider.value = amountValue / Float(amountSegmentedControl.multiplier)
    if (amountTextField.text ?? "").isEmpty {
      amountTextField.text = "0"
    }
  }
  
  @IBAction private func onIngredientNameReturn(_ sender: Any) {
    
    amountTextField.becomeFirstResponder()
  }
  
  @IBAction private func onAmountReturn(_ sender: Any) {
    
    saveIngredientAndDismiss()
  }
  
  @IBAction private func onAmountSliderValueChanged(_ sender: UISlider) {
    
    let fixed = roundf(sender.value / 1) * 1
    sender.setValue(fixed, animated: false)
    
    amountTextField.text = "\(Int(sender.value) * amountSegmentedControl.multiplier)"
    updateSaveButtonEnabled()
  }
  
  @IBAction private func onAmountSegmentedControlValueChanged(_ sender: UISegmentedControl) {
    
    updateSaveButtonEnabled()
    updateAmountSliderHidden()
    amountLabel.text = sender.measurementLabel
    amountTextField.text = "\(Int(amountSlider.value) * sender.multiplier)"
  }
  
  @IBAction private func onAmountEditingBegin(_ sender: Any) {
    
    amountTextField.selectAll(sender)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    guard let location = touches.first?.location(in: view),
      !opaqueView.frame.contains(location) else { return }

    view.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
}

extension IngredientViewController {
  
  private func setupTextFields() {
    
    hideKeyboardWhenTappedArround()
    
    nameTextField.addPaddingLeft(10.0)
    amountTextField.addPaddingLeft(10.0)
  }
  
  private func setup(withIngredient ingredient: Ingredient) {
    
    nameTextField.text = ingredient.name
    
    guard let amountValue = ingredient.amount.value
      else { return }
    
    amountTextField.text = "\(amountValue)"
    if let selectedRow = Amount.selectableCases.firstIndex(of: ingredient.amount) {
      amountSegmentedControl.selectedSegmentIndex = selectedRow
      amountLabel.text = amountSegmentedControl.measurementLabel
    }
    amountSlider.value = Float(amountValue) / Float(amountSegmentedControl.multiplier)
  }
  
  private func updateSaveButtonEnabled() {
    
    let ingredientName = nameTextField.text ?? ""
    let isValidIngredient = !existingIngredients.map { $0.name.lowercased() }
      .contains(ingredientName.lowercased())
    saveButton.isEnabled = !ingredientName.isEmpty && isValidIngredient
  }
  
  private func updateAmountSliderHidden() {
    
    let isHidden = amountSegmentedControl.selectedSegmentIndex == -1
    amountSlider.isHidden = isHidden
    amountLabel.isHidden = isHidden
    amountTextField.isHidden = isHidden
  }
  
  private func saveIngredientAndDismiss() {
    
    guard let ingredientName = nameTextField.text,
      !ingredientName.isEmpty
      else { return }
    
    var amount = Amount.none
    if let amountValue = Int(amountTextField.text ?? ""), amountValue > 0 {
      amount = Amount.selectableCases[amountSegmentedControl.selectedSegmentIndex]
      amount.value = amountValue
    }
    
    let ingredient = Ingredient(id: self.ingredient.map { $0.id },
                                name: ingredientName.trimmingCharacters(in: .whitespacesAndNewlines),
                                amount: amount)
    
    Service.db?.save(ingredient: ingredient, completion: { (error) in
      
      if let error = error {
        log.error("Unable to save ingredient with error: \(error.localizedDescription)")
      } else {
        log.debug("Succesfully saved ingredient: \(ingredient)")
      }
    })
    onIngredientAdded?(ingredient)
    
    dismissOrPop()
  }
}

extension UISegmentedControl {
  
  fileprivate var multiplier: Int {
    
    return selectedSegmentIndex == 0 ? 1 : 50
  }
  
  fileprivate var measurementLabel: String {
    
    return Amount(index: selectedSegmentIndex).abbreviation
  }
}

extension Amount {
  
  fileprivate init(index: Int) {
    
    switch index {
    case 0:
      self = .piece(amount: 0)
    case 1:
      self = .gramms(amount: 0)
    case 2:
      self = .millilitres(amount: 0)
    default:
      self = .none
    }
  }
}
