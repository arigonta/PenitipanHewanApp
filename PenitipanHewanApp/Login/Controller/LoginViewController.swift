//
//  ViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 28/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginModel = [Login]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        window = appDelegate.window
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let window = window else { return }
        if usernameTextField.text == "user" {
            dismissView(weakVar: self) {
                $0.goToUserTabbar(window: window)
            }
            
        } else if usernameTextField.text == "pet" {
            dismissView(weakVar: self) {
                $0.goToPetshopTabbar(window: window)
            }
        }
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
    }
    
    @IBAction func usernameTextField(_ sender: Any) {
        
    }
    
    @IBAction func passwordTextField(_ sender: Any) {
        
    }
}
