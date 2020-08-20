
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
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    var activeComponent: UIView?
    var pickerDeadline: PickerHelper?
    var pickerAnimal: PickerHelper?
    var animalType: [ReferenceAnimalModel]?
    var animalId: Int?
    
    var deadlinePackage = ["7 Hari", "2 Minggu", "1 Bulan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tambah Paket"
        configure()
        getData()
        createPickerView()
    }
    
    private func configure() {
        //MARK: To Stylze
        textFields.forEach { (textField) in
            textField.delegate = self
            textField.layer.borderColor = #colorLiteral(red: 0.3516459167, green: 0.7204310298, blue: 0.4399796724, alpha: 1)
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 6
        }
        descriptionTextArea.returnKeyType = UIReturnKeyType.done
        descriptionTextArea.layer.borderWidth = 1
        descriptionTextArea.layer.cornerRadius = 6
        descriptionTextArea.layer.borderColor = #colorLiteral(red: 0.3516459167, green: 0.7204310298, blue: 0.4399796724, alpha: 1)
        descriptionTextArea.delegate = self
        
        submitButton.setButtonMainStyle()
        priceTextField.keyboardType = .asciiCapableNumberPad
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let nama = nameTextField.text ?? ""
        let deadline = deadlineTextField.text ?? ""
        let harga = priceTextField.text ?? ""
        let animalType = animalTypeTextField.text ?? ""
        let desc = descriptionTextArea.text ?? ""
        var checkName = false, checkDeadline = false, checkHarga = false, checkAnimal = false
        
        if nama.isEmpty {
            nameTextField.setRedUnderLine()
        } else {
            nameTextField.setMainUnderLine()
            checkName = true
        }
        
        if deadline.isEmpty {
            deadlineTextField.setRedUnderLine()
        } else {
            deadlineTextField.setMainUnderLine()
            checkDeadline = true
        }
        
        if harga.isEmpty {
            priceTextField.setRedUnderLine()
        } else {
            priceTextField.setMainUnderLine()
            checkHarga = true
        }
        
        if animalType.isEmpty {
            animalTypeTextField.setRedUnderLine()
        } else {
            animalTypeTextField.setMainUnderLine()
            checkAnimal = true
        }
        
        if desc.isEmpty {
            
        } else {

        }
        
        if checkName && checkHarga && checkAnimal && checkDeadline {
            let model = AddReservationModel(petshop_id: UserDefaultsUtils.shared.getCurrentId(), package_name: nama, deskripsi: desc, animal_id: animalId, duration: CommonHelper.shared.convertDateToDuration(input: deadline), price: CommonHelper.shared.convertCurrencyToNumerics(input: harga))
            postData(dataPost: model)
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
            
        pickerDeadline = PickerHelper(self, self)
        pickerDeadline?.setPicker(textField: deadlineTextField, data: deadlinePackage)
    }
}

extension DetailPackageViewController: PickerHelperDelegate {
    func pickerAfterResult(value: String) { }
    
    func pickerResult(textField: UITextField, value: String) {
        if textField == deadlineTextField {
            textField.text = value
        } else if textField == animalTypeTextField {
            textField.text = value
            guard let tempAnimalId = animalType?.filter({ $0.animal_name == value}).first?.animal_id else { return }
            animalId = tempAnimalId
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

// MARK: - API
extension DetailPackageViewController {
    private func getData() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.getRequest() { [weak self] (dataList, error) in
                guard let self = self else { return }
                
                self.removeSpinner(spinner)
                if error != nil {
                    self.showToast(message: "gagal mendapatkan data")
                } else {
                    self.handleSuccessGetData(dataList)
                }
            }
        }
    }
    
    private func postData(dataPost: AddReservationModel) {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest(dataPost) { [weak self] (dataSuccess, error) in
                guard let self = self else { return }
                
                self.removeSpinner(spinner)
                if let newError = error as? ErrorResponse {
                    let message = newError.messages
                    self.showToast(message: message)
                } else {
                    self.showToast(message: "Success submit data")
                    delay(deadline: .now() + 0.55) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: POST Request Add Package
    private func sendRequest(_ dataPost: AddReservationModel, completion: ((AddReservationModel?, Error?) -> Void)? = nil) {
        
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/register"
        NetworkHelper.shared.connect(url: url, params: dataPost.representation, model: AddReservationAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    //MARK: GET Request Animal List
    private func getRequest(completion: (([ReferenceAnimalModel]?, Error?) -> Void)? = nil) {
        let url = "\(CommonHelper.shared.BASE_URL)animal/list"
        
        NetworkHelper.shared.connect(url: url, params: nil, model: ReferenceAnimalAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    private func handleSuccessGetData(_ data: [ReferenceAnimalModel]?) {
        guard let dataList = data else {
            self.showToast(message: "gagal mendapatkan data")
            return
        }
        self.animalType = dataList
        
        pickerAnimal = PickerHelper(self, self)
    
        guard let animalTypeName = animalType?.compactMap({ $0.animal_name }) else { return }
        pickerAnimal?.setPicker(textField: animalTypeTextField, data: animalTypeName)
    }
}
