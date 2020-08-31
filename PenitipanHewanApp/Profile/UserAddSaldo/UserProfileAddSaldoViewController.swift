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
    @IBOutlet weak var viewbtn: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeComponent: UIView?
    // MARK: - helper
    var pickerHelper: PickerHelper?
    // MARK: - var
    var selectedPicker: String?
    var spinner: UIView?
    var dataPicker: [String: Double] = ["Pilih Nominal": 0,
                                        "50.000": 50000,
                                        "100.000": 100000,
                                        "150.000": 150000,
                                        "200.000": 200000]
    var saldoPrefilled: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFirstView()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications(scrollView: scrollView, activeComponent: activeComponent)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let topUpSaldoTextField = saldoTF.text ?? ""
        let model = AddSaldo(id: UserDefaultsUtils.shared.getCurrentId(), top_up_saldo: CommonHelper.shared.convertCurrencyToNumerics(input: topUpSaldoTextField))
        print(model)
        postData(dataPost: model)
    }
    
    private func setFirstView() {
        initializeHidKeyboard()
        
        self.title = "Tambah Saldo"
        submitBtn.setTitle("Top Up Sekarang", for: .normal)
        saldoLbl.text = "\(saldoPrefilled ?? 0)".currencyInputFormatting()
        
        saldoTF.delegate = self
        saldoTF.text = "Pilih Nominal"
        saldoTF.setMainUnderLine()
        submitBtn.setButtonMainStyle()
        viewbtn.addDropShadow(to: .top)
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
    func pickerAfterResult(value: String) { }
    
    func pickerResult(textField: UITextField, value: String) {
        if textField == saldoTF {
            textField.text = value.currencyInputFormatting()
        }
    }
}

extension UserProfileAddSaldoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == saldoTF else { return false }
        return true
    }
}

// MARK: - API
extension UserProfileAddSaldoViewController {
    
    
    /// Method for Post data top up saldo
    /// - Parameter dataPost: model for top up saldo
    private func postData(dataPost: AddSaldo) {
        let url = "\(CommonHelper.shared.BASE_URL)user/top-up"
        self.showLoading()
        NetworkHelper.shared.connect(url: url, params: dataPost.representation, model: AddSaldo.self) { [weak self] (result) in
            guard let self = self else { return }
            self.removeLoading()
            
            switch result {
            case .failure(let err):
                self.errorResponse(error: err)
                
            case .success( _):
                self.showToast(message: "Success submit data")
                delay(deadline: .now() + 0.55) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: error handling
    /// Method for handling error response from network threading
    /// - Parameter error: Model Error From network threading
    private func errorResponse(error: Error) {
        if let newError = error as? ErrorResponse {
            self.showToast(message: newError.messages)
        }
    }
}

// MARK: - loading
extension UserProfileAddSaldoViewController {
    
    /// Show loading
    private func showLoading() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            self.spinner = spinner
        }
    }
    
    
    /// remove loading
    private func removeLoading() {
        guard let spinner = self.spinner else { return }
        self.removeSpinner(spinner)
    }
}
