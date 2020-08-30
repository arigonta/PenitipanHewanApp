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
}

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var presenter: LoginPresenterProtocol?
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window = appDelegate.window
        presenter = LoginPresenter(self, window)
        
        //MARK: For Checking User
        //        loginModel.forEach { (i) in
        //            print("username: ", i.username ?? "")
        //            print("pass: ", i.password ?? "")
        //            print("role: ", i.role ?? "")
        //        }
        
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
    
    //    func fetchCoreData() {
    //        let context = appDelegate.persistentContainer.viewContext
    //        let fetchLoginModel = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
    //        do {
    //            let results = try context.fetch(fetchLoginModel) as! [NSManagedObject]
    //            results.forEach { (i) in
    //                loginModel.append(LoginModel(
    //                    username: i.value(forKey: "username") as? String,
    //                    password: i.value(forKey: "password") as? String,
    //                    role: i.value(forKey: "role") as? String)
    //                )
    //            }
    //        } catch {
    //            print("failed")
    //        }
    //    }
    
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
}

extension LoginViewController: LoginViewProtocol {
    func handleValidationForm() {
        usernameTextField.setRedUnderLine()
        passwordTextField.setRedUnderLine()
        self.showToast(message: "Mohon cek kembali data yang anda masukkan!")
    }
}
