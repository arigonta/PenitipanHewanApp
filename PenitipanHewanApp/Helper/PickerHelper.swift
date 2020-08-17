//
//  PickerHelper.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

protocol PickerHelperDelegate: class {
    func pickerResult(textField: UITextField, value: String)
    func pickerAfterResult(value: String)
}

class PickerHelper: NSObject {
    var screen: UIViewController?
    var delegate: PickerHelperDelegate?
    var dataPicker: [String]?
    var textfield: UITextField?
    
    init(_ screen: UIViewController, _ delegate: PickerHelperDelegate?) {
        self.screen = screen
        self.delegate = delegate
        
    }
    
    public func setPicker(textField: UITextField, data: [String]) {
        self.dataPicker = data
        self.textfield = textField
        
        dismissPickerView(textField: textField)
        
        let picker = UIPickerView()
        picker.delegate = self
        textField.inputView = picker
    }
    
    private func dismissPickerView(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissPicker))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        guard let screen = screen else { return }
        screen.view.endEditing(true)
        delegate?.pickerAfterResult(value: textfield?.text ?? "")
    }
    
}

extension PickerHelper: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let data = dataPicker, let tft = textfield else { return }
        delegate?.pickerResult(textField: tft, value: data[row])
    }
}

extension PickerHelper: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker?[row] ?? ""
    }
}
