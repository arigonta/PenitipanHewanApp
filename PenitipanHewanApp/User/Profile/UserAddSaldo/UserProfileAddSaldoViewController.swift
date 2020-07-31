//
//  UserProfileAddSaldoViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserProfileAddSaldoViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var saldoTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var saldoLbl: UILabel!
    
    // MARK: - var
    var selectedPicker: String?
    var dataPicker: [String: Double] = ["Pilih Nominal": 0,
                                        "50.000": 50000,
                                        "100.000": 100000,
                                        "150.000": 150000,
                                        "200.000": 200000]
    var saldoPrefilled: Double = 100000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFirstView()
    }
    
    private func setFirstView() {
        initializeHidKeyboard()
        createPickerView()
        self.title = "Tambah Saldo"
        submitBtn.setTitle("Top Up Sekarang", for: .normal)
        saldoLbl.text = "Rp\(saldoPrefilled)"
        
        saldoTF.delegate = self
        saldoTF.text = "Pilih Nominal"
        saldoTF.setMainUnderLine()
        submitBtn.setButtonMainStyle()
    }
}

// MARK: - picker
extension UserProfileAddSaldoViewController {
    func createPickerView() {
        dismissPickerView()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        saldoTF.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissPicker))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        saldoTF.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}

extension UserProfileAddSaldoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let listValue = dataPicker.sorted { $0.value < $1.value }.compactMap { $0.value }
        let listKey = dataPicker.sorted { $0.value < $1.value }.compactMap { $0.key }
        
        let value = listValue[row]
        saldoTF.text = "Rp\(listValue[row])"
        if value == 0 {
            saldoTF.text = listKey[0]
        }
    }
}

extension UserProfileAddSaldoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let listKey = dataPicker.sorted {
            $0.value < $1.value
        }.compactMap { $0.key }
        return listKey[row]
    }
}

extension UserProfileAddSaldoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == saldoTF else { return false }
        return true
    }
}
