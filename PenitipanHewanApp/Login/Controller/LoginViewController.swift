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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if usernameTextField.text == "user" {
            if let view = storyboard.instantiateViewController(withIdentifier: "UserTabBarController") as? UserTabBarController {
                self.window?.rootViewController = view
                self.window?.makeKeyAndVisible()
            }
        } else if usernameTextField.text == "pet" {
            if let view = storyboard.instantiateViewController(withIdentifier: "PetShopTabBarController") as? PetShopTabBarController {
                self.window?.rootViewController = view
                self.window?.makeKeyAndVisible()
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

