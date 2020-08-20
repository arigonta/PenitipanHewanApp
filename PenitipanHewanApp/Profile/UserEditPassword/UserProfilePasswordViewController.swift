//
//  UserProfilePasswordViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserProfilePasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstView()
    }


    private func setFirstView() {
        initializeHidKeyboard()
        self.title = "Ubah Password"
        oldPasswordTF.placeholder = "Old Password"
        newPasswordTF.placeholder = "New Password"
        confirmNewPassword.placeholder = "confirm New Password"
        submitBtn.setTitle("Ganti Password", for: .normal)
        
        oldPasswordTF.setMainUnderLine()
        newPasswordTF.setMainUnderLine()
        confirmNewPassword.setMainUnderLine()
        submitBtn.setButtonMainStyle()
    }

}
