//
//  SignUpPresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 10/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpPresenterProtocol: class {
    var view: SignUpViewProtocol? { get set }
    var window: UIWindow? { get set }
    func validateForm(screen: SignUpViewController)
}

class SignUpPresenter: SignUpPresenterProtocol  {
    var view: SignUpViewProtocol?
    var window: UIWindow?
    
    init(_ view: SignUpViewProtocol, _ window: UIWindow?) {
        self.view = view
        self.window = window
    }
    
    func validateForm(screen: SignUpViewController) {
        
        var isEmailValidate = false
        var isUsernameValidate = false
        var isPasswordValidate = false
        var isConfirmPasswordValidate = false
        var isSelectRoleValidate = false
        var isPassEqual = false
        var isPhoneValidate = false
        var isFullNameValidate = false
        
        let email = screen.email!
        let username = screen.username!
        let password = screen.password!
        let confirmPassword = screen.confirmPassword!
        let selectRole = screen.selectRole!
        let phoneTft = screen.phoneTft!
        let fullnameTft = screen.fullnameTft!
        let addressTft = screen.addressTft!
        
        if email.text == "" || email.text?.isValidEmail == false {
            email.setRedUnderLine()
            email.textColor = .red
            isEmailValidate = false
        } else {
            email.textColor = .black
            email.setMainUnderLine()
            isEmailValidate = true
        }
        
        if username.text == "" || username.text?.count ?? 0 < 4 {
            username.setRedUnderLine()
            isUsernameValidate = false
        } else {
            username.setMainUnderLine()
            isUsernameValidate = true
        }
            
        if selectRole.text == "" {
            selectRole.setRedUnderLine()
            isSelectRoleValidate = false
        } else {
            selectRole.setMainUnderLine()
            isSelectRoleValidate = true
        }
        
        if phoneTft.text == "" || phoneTft.text?.count ?? 0 < 8 || phoneTft.text?.count ?? 0 > 13 {
            phoneTft.setRedUnderLine()
            isPhoneValidate = false
        } else {
            phoneTft.setMainUnderLine()
            isPhoneValidate = true
        }
        
        if fullnameTft.text == "" || fullnameTft.text?.count ?? 0 <= 2 {
            fullnameTft.setRedUnderLine()
            isFullNameValidate = false
        } else {
            fullnameTft.setMainUnderLine()
            isFullNameValidate = true
        }
        
        if addressTft.text == "" {
            addressTft.setRedUnderLine()
        }
        
        if password.text != confirmPassword.text || password.text == "" || confirmPassword.text == "" {
            password.setRedUnderLine()
            confirmPassword.setRedUnderLine()
            password.textColor = .red
            confirmPassword.textColor = .red
            isPassEqual = false
        } else {
            password.setMainUnderLine()
            confirmPassword.setMainUnderLine()
            password.textColor = .black
            confirmPassword.textColor = .black
            isPassEqual = true
        }
        
        if password.text == "" || password.text?.count ?? 0 < 6 {
            password.setRedUnderLine()
            isPasswordValidate = false
        } else {
            password.setMainUnderLine()
            isPasswordValidate = true
        }
        
        if confirmPassword.text == "" || confirmPassword.text?.count ?? 0 < 6 {
            confirmPassword.setRedUnderLine()
            isConfirmPasswordValidate = false
        } else {
            confirmPassword.setMainUnderLine()
            isConfirmPasswordValidate = true
        }
        
        if isEmailValidate
            && isUsernameValidate
            && isPasswordValidate
            && isConfirmPasswordValidate
            && isSelectRoleValidate
            && isPassEqual
            && isPhoneValidate
            && isFullNameValidate {
            let model = SignUpModel(username.text, password.text, selectRole.text, email.text, fullnameTft.text, phoneTft.text, addressTft.text)
            sendDataRegister(screen, model)
        }
    }
}

// MARK: - Alert
extension SignUpPresenter {
    private func openAlertSuccess(_ screen: SignUpViewController) {
        
        let action1: ((UIAlertAction) -> Void) = { _ in
            guard let window = self.window else { return }
            screen.goToLogin(window: window)
        }
        screen.openAlert(title: "",
                         message: "Register berhasil!",
                         alertStyle: .alert,
                         actionTitles: ["Ok"],
                         actionStyles: [.default],
                         actions: [action1])
    }
    
    private func openAlertFail(_ screen: SignUpViewController) {
        screen.openAlert(title: "",
                         message: "Mohon cek kembali data yang anda masukkan!",
                         alertStyle: .alert,
                         actionTitles: ["Ok"],
                         actionStyles: [.default],
                         actions: [
                            {_ in
                                print("Ok click")
                            }
        ])
    }
}

// MARK: - API
extension SignUpPresenter {
    
    /// Method for Post data Register to server
    /// - Parameters:
    ///   - screen: class View Controller
    ///   - data: model data for post register
    private func sendDataRegister(_ screen: SignUpViewController, _ data: SignUpModel) {
        let url = "\(CommonHelper.shared.BASE_URL)\(CommonHelper.shared.REGISTER_PATH)"
        let param = ["username": data.username ?? "",
                     "password": data.password ?? "",
                     "role": data.role ?? "",
                     "name": data.name ?? "",
                     "phone": data.phone ?? "",
                     "address": data.address ?? "",
                     "email": data.email ?? ""]
        
        view?.showLoading()
        NetworkHelper.shared.connect(url: url, params: param, model: SignUpAPIModel.self) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.removeLoading()
            
            switch result {
            case .failure(let err):
                self.view?.errorResponse(error: err)
                
            case .success( _):
                self.openAlertSuccess(screen)
            }
        }
    }
}
