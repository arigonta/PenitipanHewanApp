//
//  UserReservationFormViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 08/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
protocol UserReservationFormViewProtocol: class {
    func setImage(image: UIImage)
    func setRedTextfield(textfield: UITextField)
}

class UserReservationFormViewController: UIViewController {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var bgPetImageView: UIView!
    @IBOutlet weak var petNameTft: UITextField!
    @IBOutlet weak var petRasTft: UITextField!
    @IBOutlet weak var petAgeTft: UITextField!
    @IBOutlet weak var petColorTft: UITextField!
    @IBOutlet weak var petVaksinTft: DesignableUITextField!
    @IBOutlet weak var petSickCheckTft: DesignableUITextField!
    @IBOutlet weak var noteTft: UITextField!
    @IBOutlet weak var containerButton: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteStackView: UIStackView!
    @IBOutlet weak var titleDuration: UILabel!
    @IBOutlet weak var pricePackage: UILabel!
    
    var presenter: UserReservatinFormPresenterProtocol?
    var pickerHelper: PickerHelper?
    var pickerHelperSick: PickerHelper?
    var cameraHelper: CameraLibraryHelper?
    var petshopDetailModel: PetShopListModel?
    var activeComponent: UIView?
    
    let vaksin = ["Sudah", "Belum"]
    let lastSickness = ["Belum pernah sakit", "Lebih dari 1 tahun", "1 tahun lalu", "Tahun ini", "Bulan ini", "Masih sakit"]
    let hiddenSickness = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHidKeyboard()
        presenter = UserReservatinFormPresenter(view: self, petshopDetailModel: petshopDetailModel)
        setView()
        presenter?.getUserDetail(self)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications(scrollView: scrollView, activeComponent: activeComponent)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    private func setView() {
        self.title = "Reservation"
        setImage()
        setTextfield()
        setSubmitBtn()
    }
    
    private func setImage() {
        bgPetImageView.layer.cornerRadius = 16
        bgPetImageView.layer.borderWidth = 1
        bgPetImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        petImageView.isUserInteractionEnabled = true
        petImageView.addGestureRecognizer(tapImage)
    }
    
    @objc func imageTapped() {
        // open image
        presenter?.openAlertForImage(self)
    }
    
    private func setSubmitBtn() {
        titleDuration.text = "Harga penitipan hewan - \(petshopDetailModel?.duration ?? 0) hari"
        pricePackage.text = "\(petshopDetailModel?.price ?? 0)".currencyInputFormatting()
        submitBtn.layer.cornerRadius = 8
        submitBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    @objc func btnTapped() {
        // open image
        setGreenTextfield()
        presenter?.validateForm(self)
    }
    
    private func setTextfield() {
        setGreenTextfield()
        
        petNameTft.placeholder = "Nama hewan"
        petRasTft.placeholder = "Ras hewan"
        petAgeTft.placeholder = "Umur hewan"
        petColorTft.placeholder = "warna Hewan"
        petVaksinTft.placeholder = "Vaksin"
        petSickCheckTft.placeholder = "Terakhir terkena penyakit"
        
        noteStackView.isHidden = true
        
        setVaksinPicker()
        setSicknessPicker()
        
        containerButton.addDropShadow(to: .top)
    }
    
    private func setGreenTextfield() {
        petNameTft.setMainUnderLine()
        petRasTft.setMainUnderLine()
        petAgeTft.setMainUnderLine()
        petColorTft.setMainUnderLine()
        petVaksinTft.setMainUnderLine()
        petSickCheckTft.setMainUnderLine()
        noteTft.setMainUnderLine()
    }

}

// MARK: - PICKER
extension UserReservationFormViewController {
    private func setVaksinPicker() {
        pickerHelper = PickerHelper(self, self)
        pickerHelper?.setPicker(textField: petVaksinTft, data: vaksin)
    }
    
    private func setSicknessPicker() {
        pickerHelperSick = PickerHelper(self, self)
        pickerHelperSick?.setPicker(textField: petSickCheckTft, data: lastSickness)
    }
}

extension UserReservationFormViewController: PickerHelperDelegate {
    
    func pickerAfterResult(value: String) { }
    
    func pickerResult(textField: UITextField, value: String) {
        if textField == petVaksinTft {
            textField.text = value
        } else if textField == petSickCheckTft {
            textField.text = value
            let text = textField.text ?? ""
            noteStackView.isHidden = !(text == "Belum pernah sakit") ? false : true
        }
    }
}

extension UserReservationFormViewController: UserReservationFormViewProtocol {
    func setImage(image: UIImage) {
        petImageView.image = image
        petImageView.backgroundColor = .white
    }
    
    func setRedTextfield(textfield: UITextField) {
        textfield.setRedUnderLine()
    }
    
}
