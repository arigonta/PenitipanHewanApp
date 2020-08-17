//
//  UserReservationFormViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 08/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserReservationFormViewController: UIViewController {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var bgPetImageView: UIView!
    @IBOutlet weak var petNameTft: UITextField!
    @IBOutlet weak var petRasTft: UITextField!
    @IBOutlet weak var petAgeTft: UITextField!
    @IBOutlet weak var petColorTft: UITextField!
    @IBOutlet weak var petVaksinTft: UITextField!
    @IBOutlet weak var petSickCheckTft: UITextField!
    @IBOutlet weak var noteTft: UITextField!
    @IBOutlet weak var containerButton: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var pickerHelper: PickerHelper?
    var pickerHelperSick: PickerHelper?
    var cameraHelper: CameraLibraryHelper?
    
    let vaksin = ["Sudah", "Belum"]
    let lastSickness = ["Lebih dari 1 tahun", "1 tahun lalu", "Tahun ini", "Bulan ini", "Masih sakit"]
    let hiddenSickness = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()

        // Do any additional setup after loading the view.
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
        openAlert()
    }
    
    private func setSubmitBtn() {
        submitBtn.layer.cornerRadius = 16
        submitBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    @objc func btnTapped() {
        // open image
        self.dismissView(weakVar: self)
    }
    
    private func setTextfield() {
        petNameTft.setMainUnderLine()
        petRasTft.setMainUnderLine()
        petAgeTft.setMainUnderLine()
        petColorTft.setMainUnderLine()
        petVaksinTft.setMainPickerUnderLine()
        petSickCheckTft.setMainPickerUnderLine()
        noteTft.setMainUnderLine()
        
        petNameTft.placeholder = "Nama hewan"
        petRasTft.placeholder = "Ras hewan"
        petAgeTft.placeholder = "Umur hewan"
        petColorTft.placeholder = "warna Hewan"
        noteTft.placeholder = "jenis penyakit"
        petVaksinTft.placeholder = "Vaksin"
        petSickCheckTft.placeholder = "Terakhir terkena penyakit"
        
        noteTft.isHidden = true
        
        setVaksinPicker()
        setSicknessPicker()
        
        containerButton.addDropShadow(to: .top)
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
            noteTft.isHidden = !text.isEmpty ? false : true
        }
    }
}

// MARK: - camera
extension UserReservationFormViewController {
    func openAlert() {
        var actions = [AlertActionModel]()
        let newAction1 = AlertActionModel("Ambil dari kamera", .default) { (action) in
            self.openCamera()
        }
        let newAction2 = AlertActionModel("Ambil dari Galeri Foto", .default) { (action) in
            self.openGaleri()
        }
        let newAction3 = AlertActionModel("Cancel", .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        actions.append(newAction1)
        actions.append(newAction2)
        actions.append(newAction3)
        let newAlertModel = AlertModel("", "Tetapkan Foto Profil", .actionSheet, actions)
        self.setAlert(data: newAlertModel)
    }
    
    func openCamera() {
        cameraHelper = CameraLibraryHelper(self, self)
        cameraHelper?.checkAndOpenCamera()
    }
    
    func openGaleri() {
        cameraHelper = CameraLibraryHelper(self, self)
        cameraHelper?.checkAndOpenlibrary()
    }
}

extension UserReservationFormViewController: CameraLibraryHelperDelegate {
    func resultCamera(image: UIImage, base64: String) {
        bgPetImageView.backgroundColor = .white
        petImageView.image = image
    }
}
