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
    
    /// Method for Send Data login
    /// - Parameters:
    ///   - screen: class View controller
    ///   - data: model data for login
    private func sendDataLogin(_ screen: LoginViewController, _ data: LoginModel) {
        let url = "\(CommonHelper.shared.BASE_URL)\(CommonHelper.shared.LOGIN_PATH)"
        let param = ["username": data.username ?? "",
                     "password": data.password ?? ""]
        
        view?.showLoading()
        NetworkHelper.shared.connect(url: url, params: param, model: loginAPIModel.self) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.removeLoading()
            
            
            switch result {
            case .failure(let err):
                self.view?.errorResponse(error: err)
                
            case .success(let value):
                let data = value.data
                self.userDefaultUtil.setIsLogin(value: true)
                self.userDefaultUtil.setUsername(value: data.username ?? "")
                self.userDefaultUtil.setRole(value: data.role ?? "")
                self.userDefaultUtil.setCurrentId(value: data.id ?? -1)

                if data.role?.elementsEqual("petshop") ?? false {
                    self.directToPetshopTabbar(screen)
                } else {
                    self.directToCustomerTabbar(screen)
                }
            }
        }
    }
}
