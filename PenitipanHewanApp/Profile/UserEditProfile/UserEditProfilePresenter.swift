//
//  UserEditProfilePresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 21/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

protocol UserEditProfilePresenterProtocol: class {
    var view: UserEditProfileViewProtocol? { get set }
    func validateForm(screen: UserEditProfileViewController, userModel: UserModel?)
}

class UserEditProfilePresenter: UserEditProfilePresenterProtocol {
    var view: UserEditProfileViewProtocol?
    
    var currentRole = UserDefaultsUtils.shared.getRole()
    
    init(view: UserEditProfileViewProtocol) {
        self.view = view
    }
    
    func validateForm(screen: UserEditProfileViewController, userModel: UserModel?) {
        
        let nameTF = screen.namaTF!
        let emailTF = screen.emailTF!
        let phoneTF = screen.handphoneTF!
        let addressTF = screen.addressTF!
        
        var isNameValidate = false
        var isEmailValidate = false
        var isPhoneValidate = false
        var isAddressValidatte = true
        
        if emailTF.text == "" || emailTF.text?.isValidEmail == false {
            view?.setTexfieldRed(textfield: emailTF)
            isEmailValidate = false
        } else {
            isEmailValidate = true
        }
        
        if phoneTF.text == "" {
            view?.setTexfieldRed(textfield: phoneTF)
            isPhoneValidate = false
        } else {
            isPhoneValidate = true
        }
        
        if nameTF.text == "" {
            view?.setTexfieldRed(textfield: nameTF)
            isNameValidate = false
        } else {
            isNameValidate = true
        }
        
        if currentRole.elementsEqual("petshop") {
            if addressTF.text == "" {
                view?.setTexfieldRed(textfield: addressTF)
                isAddressValidatte = false
            } else {
                isAddressValidatte = true
            }
        }
        
        if isNameValidate && isEmailValidate && isPhoneValidate && isAddressValidatte {
            guard var newUserModel = userModel else { return }
            newUserModel.address = addressTF.text ?? ""
            newUserModel.email = emailTF.text ?? ""
            newUserModel.phone = phoneTF.text ?? ""
            newUserModel.name = nameTF.text ?? ""
            
            postData(screen, dataPost: newUserModel)
        }
        
    }
}

// MARK: - API
extension UserEditProfilePresenter {
    private func postData(_ screen: UserEditProfileViewController, dataPost: UserModel) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest(dataPost) { (dataSuccess, error) in
                screen.removeSpinner(spinner)
                
                if let newError = error as? ErrorResponse {
                    let message = newError.messages
                    screen.showToast(message: message)
                } else {
                    
                    guard let newDataSuccess = dataSuccess else { return }
                    let message = newDataSuccess.messages.first ?? "Success Update data"
                    screen.showToast(message: message)
                    delay(deadline: .now() + 0.55) {
                        screen.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
    }
    private func sendRequest(_ dataPost: UserModel, completion: ((SuccessPostAPIModel?, Error?) -> Void)? = nil) {
        
        let url = "\(CommonHelper.shared.BASE_URL)user/update"
        NetworkHelper.shared.connect(url: url, params: dataPost.postForUpdate, model: SuccessPostAPIModel.self) { (result) in
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
