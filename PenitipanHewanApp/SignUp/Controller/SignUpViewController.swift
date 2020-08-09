//
//  SignUpViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import CoreData

protocol SignUpViewProtocol: class {
    func update()
}

class SignUpViewController: UIViewController  {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullnameTft: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var phoneTft: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var selectRole: UITextField!
    @IBOutlet weak var containerButton: UIView!
    
    var loginModel: LoginModel?
    var isEmailValidate = false
    var isUsernameValidate = false
    var isPasswordValidate = false
    var isConfirmPasswordValidate = false
    var isSelectRoleValidate = false
    var isPassEqual = false
    var isPhoneValidate = false
    
    var presenter: SignUpPresenterProtocol?
    
    var selectedCountry: String?
    var role = ["customer", "petshop"]
    
    // MARK: - helper
    var pickerHelper: PickerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window = appDelegate.window
        presenter = SignUpPresenter(self, window)
        initializeHidKeyboard()
        
        selectRole.delegate = self
        
        // MARK: Configure
        email.placeholder = "Email"
        fullnameTft.placeholder = "Nama Lengkap"
        username.placeholder = "Username"
        phoneTft.placeholder = "No. Handphone"
        password.placeholder = "Password"
        confirmPassword.placeholder = "Confirm Password"
        selectRole.placeholder = "Select Role"
        self.title = "Sign Up"
        
        // MARK: Style
        buttonSignUp.setButtonMainStyle()
        email.setMainUnderLine()
        username.setMainUnderLine()
        fullnameTft.setMainUnderLine()
        phoneTft.setMainUnderLine()
        password.setMainUnderLine()
        confirmPassword.setMainUnderLine()
        selectRole.setMainUnderLine()
        
        containerButton.addDropShadow(to: .top)
        
        createPickerView()
    }
    
//    func saveToCoreData(_ login: LoginModel? = nil) {
//        let context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Login", in: context)
//        let newUser = NSManagedObject(entity: entity!, insertInto: context)
//
//        newUser.setValue(login?.username, forKey: "username")
//        newUser.setValue(login?.password, forKey: "password")
//        newUser.setValue(login?.role, forKey: "role")
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed saving")
//        }
//    }
    
    @IBAction func buttonSignUp(_ sender: Any) {
        presenter?.validateForm(screen: self)
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

extension SignUpViewController: SignUpViewProtocol {
    func update() {
        
    }
    
}
