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
    
    // MARK: - helper
    var pickerHelper: PickerHelper?
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
        
        self.title = "Tambah Saldo"
        submitBtn.setTitle("Top Up Sekarang", for: .normal)
        saldoLbl.text = "Rp\(saldoPrefilled)"
        
        saldoTF.delegate = self
        saldoTF.text = "Pilih Nominal"
        saldoTF.setMainUnderLine()
        submitBtn.setButtonMainStyle()
        
        createPickerView()
    }
}

// MARK: - picker
extension UserProfileAddSaldoViewController {
    func createPickerView() {
        let listKey = dataPicker.sorted {
            $0.value < $1.value
        }.compactMap { $0.key }
        
        pickerHelper = PickerHelper(self, self)
        pickerHelper?.setPicker(textField: saldoTF, data: listKey)
    }
}

extension UserProfileAddSaldoViewController: PickerHelperDelegate {
    func pickerResult(textField: UITextField, value: String) {
        if textField == saldoTF {
            textField.text = value
        }
    }
}

extension UserProfileAddSaldoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == saldoTF else { return false }
        return true
    }
}
