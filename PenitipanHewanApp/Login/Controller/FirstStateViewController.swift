//
//  FirstStateViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class FirstStateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: fix!
        // please check user login first
        delay(weakVar: self, deadline: .now() + 1.2) {
            $0.presentLogin()
        }
    }
    
    private func presentLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let nav = storyboard.instantiateViewController(withIdentifier: "LoginNav") as? UINavigationController,
            let view = nav.viewControllers.first as? LoginViewController
        else { return }
        view.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

}
