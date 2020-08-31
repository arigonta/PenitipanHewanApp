//
//  UserProfilePasswordViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserProfilePasswordViewController: UIViewController {
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    var spinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstView()
    }
    
    
    private func setFirstView() {
        initializeHidKeyboard()
        self.title = "Ubah Password"
        newPasswordTF.placeholder = "New Password"
        confirmNewPassword.placeholder = "confirm New Password"
        submitBtn.setTitle("Ganti Password", for: .normal)
        
        newPasswordTF.setMainUnderLine()
        confirmNewPassword.setMainUnderLine()
        submitBtn.setButtonMainStyle()
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        
        var isConfirmPassValidate = false
        
        if newPasswordTF.text == confirmNewPassword.text {
            isConfirmPassValidate = true
        } else {
            isConfirmPassValidate = false
            newPasswordTF.setRedUnderLine()
            confirmNewPassword.setRedUnderLine()
        }
        
        if isConfirmPassValidate {
            postData(id: UserDefaultsUtils.shared.getCurrentId(), pass: confirmNewPassword.text ?? "")
        }
        
    }
}

// MARK: - loading
extension UserProfilePasswordViewController {
    
    /// Show loading
    private func showLoading() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            self.spinner = spinner
        }
    }
    
    
    /// remove loading
    private func removeLoading() {
        guard let spinner = self.spinner else { return }
        self.removeSpinner(spinner)
    }
}

extension UserProfilePasswordViewController {
    
    /// Method for post data change password
    /// - Parameters:
    ///   - id: **Int** id from current user
    ///   - pass: **String** new password
    func postData(id: Int, pass: String) {
        let url = "\(CommonHelper.shared.BASE_URL)user/password/change"
        let param: [String: Any] = ["id": id, "password": pass]
        
        showLoading()
        NetworkHelper.shared.connect(url: url, params: param, model: History.self) { [weak self] (result) in
            guard let self = self else { return }
            self.removeLoading()
            
            switch result {
            case .failure(let err):
                self.errorResponse(error: err)
                
            case .success( _):
                self.showToast(message: "Success submit data")
                delay(deadline: .now() + 0.6) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: error handling
    /// Method for handling error response from network threading
    /// - Parameter error: Model Error From network threading
    private func errorResponse(error: Error) {
        if let newError = error as? ErrorResponse {
            self.showToast(message: newError.messages)
        }
    }
    
}
