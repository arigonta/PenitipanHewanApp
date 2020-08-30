//
//  ResetPasswordViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 31/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var emailTxtField: UITextField!
    var spinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reset Password"
        self.navigationController?.navigationBar.topItem?.title = " "
        submitBtn.setButtonMainStyle()
        emailTxtField.setMainUnderLine()
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        var isEmailValidate = false
        
        if emailTxtField.text == "" {
            emailTxtField.setRedUnderLine()
            isEmailValidate = false
        } else {
            emailTxtField.setMainUnderLine()
            isEmailValidate = true
        }
        
        if isEmailValidate {
            postData(email: emailTxtField.text ?? "")
        }
    }
}

extension ResetPasswordViewController {
    // MARK: Post Action Petshop
    /// Method for post Action Changed perDay
    /// - Parameter dataPost: Model Action perDay
    func postData(email: String) {
        let url = "\(CommonHelper.shared.BASE_URL)user/password/reset"
        let param: [String: Any] = ["email": email]
        
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
            self.showToast(message: "Email tidak di temukan!")
        }
    }
    
}

// MARK: - loading
extension ResetPasswordViewController {
    
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
