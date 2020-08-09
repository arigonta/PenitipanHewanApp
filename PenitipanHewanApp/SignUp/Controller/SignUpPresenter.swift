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
        
        if email.text == "" || email.text?.isValidEmail == false {
            email.setRedUnderLine()
            email.textColor = .red
            isEmailValidate = false
        } else {
            email.textColor = .black
            email.setMainUnderLine()
            isEmailValidate = true
        }
        
        if username.text == "" {
            username.setRedUnderLine()
            isUsernameValidate = false
        } else {
            username.setMainUnderLine()
            isUsernameValidate = true
        }
        
        if password.text == "" {
            password.setRedUnderLine()
            isPasswordValidate = false
        } else {
            password.setMainUnderLine()
            isPasswordValidate = true
        }
        
        if confirmPassword.text == "" {
            confirmPassword.setRedUnderLine()
            isConfirmPasswordValidate = false
        } else {
            confirmPassword.setMainUnderLine()
            isConfirmPasswordValidate = true
        }
        
        if selectRole.text == "" {
            selectRole.setRedUnderLine()
            isSelectRoleValidate = false
        } else {
            selectRole.setMainUnderLine()
            isSelectRoleValidate = true
        }
        
        if phoneTft.text == "" {
            phoneTft.setRedUnderLine()
            isPhoneValidate = false
        } else {
            phoneTft.setMainUnderLine()
            isPhoneValidate = true
        }
        
        if fullnameTft.text == "" {
            fullnameTft.setRedUnderLine()
            isFullNameValidate = false
        } else {
            fullnameTft.setMainUnderLine()
            isFullNameValidate = true
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
        
        if isEmailValidate
            && isUsernameValidate
            && isPasswordValidate
            && isConfirmPasswordValidate
            && isSelectRoleValidate
            && isPassEqual
            && isPhoneValidate
            && isFullNameValidate {
            let model = SignUpModel(username.text, password.text, selectRole.text, email.text, fullnameTft.text, phoneTft.text, nil)
            sendDataRegister(screen, model)
            
            
        }
    }
}

// MARK: - Alert
extension SignUpPresenter {
    private func openAlertSuccess(_ screen: SignUpViewController) {
        screen.openAlert(title: "",
                         message: "Register berhasil!",
                         alertStyle: .alert,
                         actionTitles: ["Ok"],
                         actionStyles: [.default],
                         actions: [
                            {_ in
                                guard let window = self.window else { return }
                                screen.goToLogin(window: window)
                            }
        ])
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
    
    private func sendDataRegister(_ screen: SignUpViewController, _ data: SignUpModel) {
        sendRequest(data: data) { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                self.openAlertFail(screen)
            } else {
                self.openAlertSuccess(screen)
            }
        }
    }
    
    private func sendRequest(data: SignUpModel, completion: ((SignUpModel?, Error?) -> Void)? = nil) {
        guard let urlFromString = URL(string: CommonHelper.shared.BASE_URL + CommonHelper.shared.REGISTER_PATH) else { return }
        let urlComponent = URLComponents(string: urlFromString.absoluteString)
        let url = urlComponent?.url?.absoluteString ?? ""
        
        
        let param = ["username": data.username ?? "",
                                    "password": data.password ?? "",
                                    "role": data.role ?? "",
                                    "name": data.name ?? "",
                                    "phone": data.phone ?? "",
                                    "email": data.email ?? ""]
        
        NetworkHelper.shared.connect(url: url, params: param, model: SignUpAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
}
