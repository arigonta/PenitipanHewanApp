
//
//  DetailPackageViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 14/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class DetailPackageViewController: UIViewController {
    
    @IBOutlet weak var animalTypeTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var animalTypeLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    var activeComponent: UIView?
    var pickerDeadline: PickerHelper?
    var pickerAnimal: PickerHelper?
    
    var deadlinePackage = ["7 Hari", "2 Minggu", "1 Bulan"]
    var pet = ["Kucing", "Anjing", "Burung", "Reptil"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tambah Paket"
        
        descriptionTextArea.returnKeyType = UIReturnKeyType.done
        priceTextField.keyboardType = .asciiCapableNumberPad
        submitButton.setButtonMainStyle()
        delegate()
        createPickerView()
    }
    
    private func delegate() {
        priceTextField.delegate = self
        deadlineTextField.delegate = self
        animalTypeTextField.delegate = self
        descriptionTextArea.delegate = self
        nameTextField.delegate = self
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let nama = nameTextField.text ?? ""
        let deadline = deadlineTextField.text ?? ""
        let harga = priceTextField.text ?? ""
        let animalType = animalTypeTextField.text ?? ""
        let desc = descriptionTextArea.text ?? ""
        var checkName = false, checkDeadline = false, checkHarga = false, checkAnimal = false , checkDesc = false
        
        if nama.isEmpty {
            nameTextField.setRedUnderLine()
        } else {
            checkName = true
        }
        
        if deadline.isEmpty {
            deadlineTextField.setRedUnderLine()
        } else {
            checkDeadline = true
        }
        
        if harga.isEmpty {
            priceTextField.setRedUnderLine()
        } else {
            checkHarga = true
        }
        
        if animalType.isEmpty {
            animalTypeTextField.setRedUnderLine()
        } else {
            checkAnimal = true
        }
        
        if desc.isEmpty {
            
        } else {
            checkDesc = true
        }
        
        if checkName && checkDesc && checkHarga && checkAnimal && checkDeadline {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension DetailPackageViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}

extension DetailPackageViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == priceTextField {
            let text = (textField.text ?? "") as NSString
            let currency = text.replacingCharacters(in: range, with: string)
            priceTextField.text = currency.currencyInputFormatting()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailPackageViewController {
    func createPickerView() {
        pickerAnimal = PickerHelper(self, self)
        pickerAnimal?.setPicker(textField: animalTypeTextField, data: pet)
        
        pickerDeadline = PickerHelper(self, self)
        pickerDeadline?.setPicker(textField: deadlineTextField, data: deadlinePackage)
    }
}

extension DetailPackageViewController: PickerHelperDelegate {
    func pickerResult(textField: UITextField, value: String) {
        if textField == deadlineTextField {
            textField.text = value
        } else if textField == animalTypeTextField {
            textField.text = value
        }
    }
}

extension DetailPackageViewController {
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications(scrollView: scrollView, activeComponent: activeComponent)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
}
