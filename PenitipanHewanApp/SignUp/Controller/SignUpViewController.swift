//
//  SignUpViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController  {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var selectRole: UITextField!
    
    var loginModel: LoginModel?
    var isEmailValidate = false
    var isUsernameValidate = false
    var isPasswordValidate = false
    var isConfirmPasswordValidate = false
    var isSelectRoleValidate = false
    var isPassEqual = false
    
    var selectedCountry: String?
    var role = ["User", "Petshop"]
    
    // MARK: - helper
    var pickerHelper: PickerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window = appDelegate.window
        
        initializeHidKeyboard()
        
        selectRole.delegate = self
        
        // MARK: Configure
        email.placeholder = "Email"
        username.placeholder = "Username"
        password.placeholder = "Password"
        confirmPassword.placeholder = "Confirm Password"
        selectRole.placeholder = "Select Role"
        self.title = "Sign Up"
        
        // MARK: Style
        buttonSignUp.setButtonMainStyle()
        email.setMainUnderLine()
        username.setMainUnderLine()
        password.setMainUnderLine()
        confirmPassword.setMainUnderLine()
        selectRole.setMainUnderLine()
        
        
        
        createPickerView()
    }
    
    func saveToCoreData(_ login: LoginModel? = nil) {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Login", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
    
        newUser.setValue(login?.username, forKey: "username")
        newUser.setValue(login?.password, forKey: "password")
        newUser.setValue(login?.role, forKey: "role")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    @IBAction func buttonSignUp(_ sender: Any) {
        
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
        
        if isEmailValidate && isUsernameValidate && isPasswordValidate && isConfirmPasswordValidate && isSelectRoleValidate && isPassEqual {
            loginModel = LoginModel(username: username.text, password: password.text, role: selectRole.text, email: email.text)
            
            saveToCoreData(loginModel)
            
            guard let window = window else { return }
            self.goToLogin(window: window)
        }
        
    }
    
}

// MARK: - textfield delegate
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == selectRole {
            return false
        } else {
            return true
        }
    }
}

// MARK: - picker

extension SignUpViewController {
    func createPickerView() {
        pickerHelper = PickerHelper(self, self)
        pickerHelper?.setPicker(textField: selectRole, data: role)
    }
}

extension SignUpViewController: PickerHelperDelegate {
    func pickerResult(textField: UITextField, value: String) {
        if textField == selectRole {
            textField.text = value
        }
    }
}
