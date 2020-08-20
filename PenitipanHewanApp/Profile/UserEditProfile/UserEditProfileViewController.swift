//
//  UserEditProfileViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserEditProfileViewController: UIViewController {

    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var handphoneTF: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFirstView()
    }

    private func setFirstView() {
        initializeHidKeyboard()
        self.title = "Edit Profile"
        
        namaTF.placeholder = "Nama"
        emailTF.placeholder = "Email"
        handphoneTF.placeholder = "No. Handphone"
        submit.setTitle("Submit", for: .normal)
        
        namaTF.setMainUnderLine()
        emailTF.setMainUnderLine()
        handphoneTF.setMainUnderLine()
        
        submit.setButtonMainStyle()
    }
}
