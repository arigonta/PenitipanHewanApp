//
//  FirstStateViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class FirstStateViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var isLoggedIn = false
    var lastRole = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggedIn = UserDefaultsUtils.shared.getIsLogin()
        lastRole = UserDefaultsUtils.shared.getRole()
        window = appDelegate.window
        isLogin()
    }
    
    private func presentLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let nav = storyboard.instantiateViewController(withIdentifier: "LoginNav") as? UINavigationController,
            let view = nav.viewControllers.first as? LoginViewController
            else { return }
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    private func isLogin() {
        if isLoggedIn {
            guard let window = window else { return }
            if lastRole.contains("customer") {
                goToUserTabbar(window: window)
            } else {
                goToPetshopTabbar(window: window)
            }
        } else {
            delay(weakVar: self, deadline: .now()) {
                $0.presentLogin()
            }
        }
    }
    
}
