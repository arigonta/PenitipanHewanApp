//
//  PetshopProfileViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class PetshopProfileViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        window = appDelegate.window
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        guard let window = window else { return }
        self.goToLogin(window: window)
    }

}
