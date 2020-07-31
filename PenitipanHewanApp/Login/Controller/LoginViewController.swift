//
//  ViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 28/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    var loginModel = [LoginModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var userDefault = UserDefaults.standard
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginModel.removeAll()
        window = appDelegate.window
        fetchCoreData()
        isLogin()
        
        //MARK: For Checking User Colmek
        loginModel.forEach { (i) in
            print("username: ", i.username ?? "")
            print("pass: ", i.password ?? "")
            print("role: ", i.role ?? "")
        }
        
        // MARK: Configure
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        
        // MARK: Style
        loginButton.setButtonMainStyle()
        signUpButton.setButtonMainStyle()
        usernameTextField.setMainUnderLine()
        passwordTextField.setMainUnderLine()
        titleLabel.textColor = ColorHelper.instance.mainGreen
    }
    
    private func isLogin() {
        let isLoggedIn = userDefault.bool(forKey: "isLoggedIn")
        let lastRole = userDefault.string(forKey: "lastRole")
        if isLoggedIn {
            guard let window = window else { return }
            if lastRole?.contains("User") ?? false {
                dismissView(weakVar: self) {
                    $0.goToUserTabbar(window: window)
                }
            } else {
                dismissView(weakVar: self) {
                    $0.goToPetshopTabbar(window: window)
                }
            }
        }
    }
    
    func fetchCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchLoginModel = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        do {
            let results = try context.fetch(fetchLoginModel) as! [NSManagedObject]
            results.forEach { (i) in
                loginModel.append(LoginModel(
                    username: i.value(forKey: "username") as? String,
                    password: i.value(forKey: "password") as? String,
                    role: i.value(forKey: "role") as? String)
                )
            }
        } catch {
            print("failed")
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let window = window else { return }
        let isLoggedIn = true
        //for temporary login using coredata aka colmek
        loginModel.forEach { (i) in
            if usernameTextField.text == i.username && usernameTextField.text == i.password {
                userDefault.set(isLoggedIn, forKey: "isLoggedIn")
                userDefault.set(i.role, forKey: "lastRole")
                if i.role?.contains("Petshop") ?? false {
                    dismissView(weakVar: self) {
                        $0.goToPetshopTabbar(window: window)
                    }
                } else {
                    dismissView(weakVar: self) {
                        $0.goToUserTabbar(window: window)
                    }
                }
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let detailMovieVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(detailMovieVC, animated: true)
        }
    }
    
    @IBAction func usernameTextField(_ sender: Any) {
        
    }
    
    @IBAction func passwordTextField(_ sender: Any) {
        
    }
}
