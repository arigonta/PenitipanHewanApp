//
//  ViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 28/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButton(_ sender: Any) {
        print(usernameTextField.text)
        print(passwordTextField.text)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
    }
    @IBAction func usernameTextField(_ sender: Any) {
    }
    @IBAction func passwordTextField(_ sender: Any) {
    }
}

