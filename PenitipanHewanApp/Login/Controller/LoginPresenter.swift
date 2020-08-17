//
//  LoginPresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 14/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

protocol LoginPresenterProtocol: class {
    var view: LoginViewProtocol? { get set }
    var window: UIWindow? { get set }
    func validateForm(_ screen: LoginViewController)
    func directToPetshopTabbar(_ screen: LoginViewController)
    func directToCustomerTabbar(_ screen: LoginViewController)
    func directToSignUpScreen(_ screen: LoginViewController)
}

class LoginPresenter: LoginPresenterProtocol {
    var view: LoginViewProtocol?
    var window: UIWindow?
    
    // MARK: Injection
    var userDefaultUtil = UserDefaultsUtils.shared
    
    init(_ view: LoginViewProtocol, _ window: UIWindow?) {
        self.view = view
        self.window = window
    }
    
    func validateForm(_ screen: LoginViewController) {
        let usernameText = screen.usernameTextField.text ?? ""
        let passwordText = screen.passwordTextField.text ?? ""
        
        let model = LoginModel(username: usernameText, password: passwordText)
        
        if !usernameText.isEmpty && !passwordText.isEmpty {
            sendDataLogin(screen, model)
        } else {
            view?.handleValidationForm()
        }
    }
    
    // MARK: Direction
    func directToPetshopTabbar(_ screen: LoginViewController) {
        guard let window = window else { return }
        screen.dismissView(weakVar: screen) {
            $0.goToPetshopTabbar(window: window)
        }
    }
    func directToCustomerTabbar(_ screen: LoginViewController) {
        guard let window = window else { return }
        screen.dismissView(weakVar: screen) {
            $0.goToUserTabbar(window: window)
        }
    }
    
    func directToSignUpScreen(_ screen: LoginViewController) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let detailMovieVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            screen.navigationController?.pushViewController(detailMovieVC, animated: true)
        }
    }
    
}

// MARK: - API
extension LoginPresenter {
    
    private func sendDataLogin(_ screen: LoginViewController, _ data: LoginModel) {
        screen.showSpinner { [weak self] spinner in
            guard let self = self else { return }
            
            self.sendRequest(data: data) { [weak self] (dataAPI, error) in
                guard let self = self else { return }
                
                screen.removeSpinner(spinner)
                if error != nil {
                    screen.showToast(message: "Mohon cek kembali data yang anda masukkan!")
                } else {
                    guard let dataAPI = dataAPI else { return }
                    self.handleSuccessLogin(screen, dataAPI)
                }
            }
        }
        
    }
    
    private func sendRequest(data: LoginModel, completion: ((LoginModel?, Error?) -> Void)? = nil) {
        let url = "\(CommonHelper.shared.BASE_URL)\(CommonHelper.shared.LOGIN_PATH)"
        let param = ["username": data.username ?? "",
                     "password": data.password ?? ""]
        
        NetworkHelper.shared.connect(url: url, params: param, model: loginAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    func handleSuccessLogin(_ screen: LoginViewController, _ data: LoginModel) {
        userDefaultUtil.setIsLogin(value: true)
        userDefaultUtil.setUsername(value: data.username ?? "")
        userDefaultUtil.setRole(value: data.role ?? "")
        userDefaultUtil.setCurrentId(value: data.id ?? -1)

        if data.role?.elementsEqual("petshop") ?? false {
            self.directToPetshopTabbar(screen)
        } else {
            self.directToCustomerTabbar(screen)
        }
    }
}
