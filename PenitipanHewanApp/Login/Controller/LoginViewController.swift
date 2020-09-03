//
//  ViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 28/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import CoreData

protocol LoginViewProtocol: class {
    func handleValidationForm()
    func errorResponse(error: Error?)
    func showLoading()
    func removeLoading()
}

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var presenter: LoginPresenterProtocol?
    var spinner: UIView?
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window = appDelegate.window
        presenter = LoginPresenter(self, window)
        
        // MARK: Configure
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // MARK: Style
        loginButton.setButtonMainStyle()
        signUpButton.setButtonMainStyle()
        usernameTextField.setMainUnderLine()
        passwordTextField.setMainUnderLine()
        titleLabel.textColor = ColorHelper.instance.mainGreen
    }
    
    @IBAction func loginButton(_ sender: Any) {
        view.endEditing(true)
        usernameTextField.setMainUnderLine()
        passwordTextField.setMainUnderLine()
        presenter?.validateForm(self)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        presenter?.directToSignUpScreen(self)
    }
    
    @IBAction func usernameTextField(_ sender: Any) {
        
    }
    
    @IBAction func passwordTextField(_ sender: Any) {
        
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ResetPassword", bundle: nil)
        if let resetPassVC = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController {
            self.navigationController?.pushViewController(resetPassVC, animated: true)
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usernameTextField {
            let text = (textField.text ?? "") as NSString
            let usernameTxt = text.replacingCharacters(in: range, with: string)
            usernameTextField.text = usernameTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            return false
        } else if textField == passwordTextField {
            let text = (textField.text ?? "") as NSString
            let passwordTxt = text.replacingCharacters(in: range, with: string)
            textField.text = passwordTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            return false
        } else {
            return true
        }
    }
}

extension LoginViewController: LoginViewProtocol {
    
    func errorResponse(error: Error?) {
        if let newError = error as? ErrorResponse {
            self.showToast(message: newError.messages)
        }
    }
    
    /// Show loading
    func showLoading() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            self.spinner = spinner
        }
    }
    
    /// remove loading
    func removeLoading() {
        guard let spinner = self.spinner else { return }
        self.removeSpinner(spinner)
    }
    
    func handleValidationForm() {
        usernameTextField.setRedUnderLine()
        passwordTextField.setRedUnderLine()
        self.showToast(message: "Mohon cek kembali data yang anda masukkan!")
    }
}
