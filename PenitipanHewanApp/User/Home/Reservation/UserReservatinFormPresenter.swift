//
//  UserReservatinFormPresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 19/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

protocol UserReservatinFormPresenterProtocol: class {
    var view: UserReservationFormViewProtocol? { get set }
    var modelPost: ReservationModel? { get set }
    var cameraHelper: CameraLibraryHelper? { get set }
    var petshopDetailModel: PetShopListModel? { get set }
    var userModel: UserModel? { get set }
    
    func getUserDetail(_ screen: UserReservationFormViewController)
    func openAlertForImage(_ screen: UserReservationFormViewController)
    func validateForm(_ screen: UserReservationFormViewController)
}

class UserReservatinFormPresenter: UserReservatinFormPresenterProtocol {
    var view: UserReservationFormViewProtocol?
    var modelPost: ReservationModel?
    var cameraHelper: CameraLibraryHelper?
    var petshopDetailModel: PetShopListModel?
    var userModel: UserModel?
    
    var currentId = UserDefaultsUtils.shared.getCurrentId()
    
    init(view: UserReservationFormViewProtocol, petshopDetailModel: PetShopListModel?) {
        self.view = view
        self.petshopDetailModel = petshopDetailModel
    }
    
    func getUserDetail(_ screen: UserReservationFormViewController) {
        getData(screen)
    }
    
    func openAlertForImage(_ screen: UserReservationFormViewController) {
        var actions = [AlertActionModel]()
        let newAction1 = AlertActionModel("Ambil dari kamera", .default) { (action) in
            self.openCamera(screen)
        }
        let newAction2 = AlertActionModel("Ambil dari Galeri Foto", .default) { (action) in
            self.openGaleri(screen)
        }
        let newAction3 = AlertActionModel("Cancel", .cancel) { (action) in
            screen.dismiss(animated: true, completion: nil)
        }
        actions.append(newAction1)
        actions.append(newAction2)
        actions.append(newAction3)
        let newAlertModel = AlertModel("", "Tetapkan Foto Profil", .actionSheet, actions)
        screen.setAlert(data: newAlertModel)
    }
    
    func validateForm(_ screen: UserReservationFormViewController) {
        var isNameValidate = false
        var isRacialValidate = false
        var isAgeValidate = false
        var isColorValidate = false
        var isVaksinValidate = false
        var isSicknessCheckValidate = false
        var isNoteValidate = false
        
        let name = screen.petNameTft!
        let racial = screen.petRasTft!
        let age = screen.petAgeTft!
        let color = screen.petColorTft!
        let vaksin = screen.petVaksinTft!
        let sicknessCheck = screen.petSickCheckTft!
        let note = screen.noteTft!
        
        var isWithNote: Bool = false
        var isWasVaccine: Bool = false
        
        if name.text == "" {
            view?.setRedTextfield(textfield: name)
            isNameValidate = false
        } else {
            name.setMainUnderLine()
            isNameValidate = true
        }
        
        if racial.text == "" {
            view?.setRedTextfield(textfield: racial)
            racial.setRedUnderLine()
            isRacialValidate = false
        } else {
            racial.setMainUnderLine()
            isRacialValidate = true
        }
        
        if age.text == "" {
            view?.setRedTextfield(textfield: age)
            isAgeValidate = false
        } else {
            age.setMainUnderLine()
            isAgeValidate = true
        }
        
        if color.text == "" {
            view?.setRedTextfield(textfield: color)
            isColorValidate = false
        } else {
            color.setMainUnderLine()
            isColorValidate = true
        }
        
        if vaksin.text == "" {
            view?.setRedTextfield(textfield: vaksin)
            isVaksinValidate = false
        } else {
            vaksin.setMainUnderLine()
            isVaksinValidate = true
            isWasVaccine = (vaksin.text ?? "").contains("Sudah") ? true : false
        }
        
        if sicknessCheck.text == "" {
            view?.setRedTextfield(textfield: sicknessCheck)
            isSicknessCheckValidate = false
        } else {
            sicknessCheck.setMainUnderLine()
            isSicknessCheckValidate = true
        }
        
        if sicknessCheck.text != "Belum pernah sakit" {
            if note.text == "" {
                view?.setRedTextfield(textfield: note)
                isNoteValidate = false
            } else {
                note.setMainUnderLine()
                isNoteValidate = true
            }
        }
        
        if sicknessCheck.text != "Belum pernah sakit" {
            if isNameValidate
                && isRacialValidate
                && isAgeValidate
                && isColorValidate
                && isVaksinValidate
                && isSicknessCheckValidate
                && isNoteValidate {
                
                isWithNote = true
                
            } else {
                screen.showToast(message: "Cek kembali data yang anda masukkan.")
                return
            }
        } else {
            if isNameValidate
                && isRacialValidate
                && isAgeValidate
                && isColorValidate
                && isVaksinValidate
                && isSicknessCheckValidate {
                
                isWithNote = false
            } else {
                screen.showToast(message: "Cek kembali data yang anda masukkan.")
                return
            }
        }
        
        guard let packageId = petshopDetailModel?.petshop_package_id else { return }
        let model = ReservationModel(petshop_package_id: packageId,
                                     user_id: currentId,
                                     animal_name: name.text,
                                     animal_racial: racial.text,
                                     age: Int(age.text ?? "0"),
                                     color: color.text,
                                     is_vaccine: isWasVaccine,
                                     last_time_got_sick: sicknessCheck.text,
                                     note: note.text)
        
        checkSaldo(screen, modelPost: model)

    }
}

// MARK: - API
extension UserReservatinFormPresenter {
    func checkSaldo(_ screen: UserReservationFormViewController, modelPost: ReservationModel) {
        let userSaldo = userModel?.saldo ?? 0
        let saldo = petshopDetailModel?.price ?? 0
        
        if userSaldo < saldo {
            showAlertSaldo(screen)
        } else {
           postData(screen, dataPost: modelPost)
        }
    }
    
    func showAlertSaldo(_ screen: UserReservationFormViewController) {
        let closureActioin: ((UIAlertAction) -> Void) = { _ in }
        screen.openAlert(title: "Saldo Anda Kurang", message: "Mohon mengisi saldo di menu Profile - isi saldo", alertStyle: .alert, actionTitles: ["Mengerti"], actionStyles: [.default], actions: [closureActioin])
    }
}

// MARK: - API
extension UserReservatinFormPresenter {
    
    private func getData(_ screen: UserReservationFormViewController) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            let url = "\(CommonHelper.shared.BASE_URL)user/\(self.currentId)"
            
            self.sendRequest(url, nil, UserAPIModel.self) { (dataSuccess, error) in
                screen.removeSpinner(spinner)
                
                if let newError = error as? ErrorResponse {
                    let message = newError.messages
                    screen.showToast(message: message)
                    
                } else {
                    guard let model = dataSuccess?.data else { return }
                    self.userModel = model
                }
            }
        }
    }
    
    private func postData(_ screen: UserReservationFormViewController, dataPost: ReservationModel) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            let params = dataPost.representation
            let url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation"
            
            self.sendRequest(url, params, ReservationAPIModel.self) { (dataSuccess, error) in
                screen.removeSpinner(spinner)
                
                if let newError = error as? ErrorResponse {
                    let message = newError.messages
                    screen.showToast(message: message)
                } else {
                    
                    screen.showToast(message: "Success submit data")
                    delay(deadline: .now() + 0.55) {
                        screen.navigationController?.tabBarController?.selectedIndex = 1
                        screen.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }
            }
        }
        
    }
    private func sendRequest<T:Decodable>(_ url: String,
                                          _ params: [String: Any]?,
                                          _ model: T.Type,
                                          completion: ((T?, Error?) -> Void)? = nil) {
        
        NetworkHelper.shared.connect(url: url, params: params, model: model.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value, nil)
            }
        }
    }
}

// MARK: - camera & photo library
extension UserReservatinFormPresenter {
    func openCamera(_ screen: UserReservationFormViewController) {
        cameraHelper = CameraLibraryHelper(screen, self)
        cameraHelper?.checkAndOpenCamera()
    }
    
    func openGaleri(_ screen: UserReservationFormViewController) {
        cameraHelper = CameraLibraryHelper(screen, self)
        cameraHelper?.checkAndOpenlibrary()
    }
}

extension UserReservatinFormPresenter: CameraLibraryHelperDelegate {
    func resultCamera(image: UIImage, base64: String) {
        view?.setImage(image: image)
    }
}
