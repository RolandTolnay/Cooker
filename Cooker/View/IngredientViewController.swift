//
//  IngredientViewController.swift
//  Cooker
//
//  Created by Roland Tolnay on 09/02/2019.
//  Copyright © 2019 iQuest Technologies. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController {

  var ingredient: Ingredient?

  @IBOutlet private weak var nameTextField: UITextField!
  @IBOutlet private weak var amountTextField: UITextField!
  @IBOutlet private weak var amountPickerView: UIPickerView!
  @IBOutlet private weak var doneButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    hideKeyboardWhenTappedArround()

    setupPickerView()
    ingredient.map { setup(withIngredient: $0) }
    updatePickerViewHidden()
    updateDoneButtonEnabled()

    if !isPresentedModally {
      navigationItem.leftBarButtonItem = nil
      navigationItem.hidesBackButton = false
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    nameTextField.becomeFirstResponder()
  }

  @IBAction private func onDoneTapped(_ sender: Any) {

    saveIngredientAndDismiss()
  }

  @IBAction private func onCancelTapped(_ sender: Any) {

    dismissOrPop()
  }

  @IBAction private func onIngredientNameChanged(_ sender: Any) {

    updateDoneButtonEnabled()
  }

  @IBAction private func onAmountChanged(_ sender: Any) {

    updatePickerViewHidden()
  }

  @IBAction func onIngredientNameReturn(_ sender: Any) {

    amountTextField.becomeFirstResponder()
  }

  @IBAction func onAmountReturn(_ sender: Any) {

    saveIngredientAndDismiss()
  }
}

extension IngredientViewController {

  private func setupPickerView() {

    amountPickerView.dataSource = self
    amountPickerView.delegate = self
  }

  private func setup(withIngredient ingredient: Ingredient) {

    nameTextField.text = ingredient.name

    guard let amountValue = ingredient.amount.value
      else { return }

    amountTextField.text = "\(amountValue)"
    if let selectedRow = Amount.selectableCases.firstIndex(of: ingredient.amount) {
      amountPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    }
  }

  private func updatePickerViewHidden() {

    amountPickerView.isHidden = (amountTextField.text ?? "").isEmpty
  }

  private func updateDoneButtonEnabled() {

    doneButton.isEnabled = !(nameTextField.text ?? "").isEmpty
  }

  private func saveIngredientAndDismiss() {

    guard let ingredientName = nameTextField.text,
      !ingredientName.isEmpty
      else { return }

    var amount = Amount.none
    if let amountValue = Int(amountTextField.text ?? "") {
      amount = Amount.selectableCases[amountPickerView.selectedRow(inComponent: 0)]
      amount.value = amountValue
    }

    let ingredient = Ingredient(id: self.ingredient.map { $0.id },
                                name: ingredientName,
                                amount: amount)

    Service.db?.save(ingredient: ingredient, completion: { (error) in

      if let error = error {
        print("Unable to save ingredient with error: \(error.localizedDescription)")
      } else {
        print("Succesfully saved ingredient: \(ingredient)")
      }
    })

    dismissOrPop()
  }
}

extension IngredientViewController: UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {

    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

    return Amount.selectableCases.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    return Amount.selectableCases[row].title
  }
}

extension IngredientViewController: UIPickerViewDelegate {

}
