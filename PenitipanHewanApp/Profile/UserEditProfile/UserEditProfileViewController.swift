//
//  UserEditProfileViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

protocol UserEditProfileViewProtocol: class {
    func setTexfieldRed(textfield: UITextField)
    func successEditData(message: String)
    func showLoading()
    func removeLoading()
    func errorResponse(error: Error)
}

class UserEditProfileViewController: UIViewController {

    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var handphoneTF: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var containerSubmitBtn: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeComponent: UIView?
    var spinner: UIView?
    var userModel: UserModel?
    var currentRole = UserDefaultsUtils.shared.getRole()
    var presenter: UserEditProfilePresenterProtocol?
    weak var delegate: RefreshProfilePageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeHidKeyboard()
        presenter = UserEditProfilePresenter(view: self)
        setFirstView()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications(scrollView: scrollView, activeComponent: activeComponent)
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }

    private func setFirstView() {
        initializeHidKeyboard()
        self.title = "Edit Profile"
        
        namaTF.placeholder = "Nama"
        emailTF.placeholder = "Email"
        handphoneTF.placeholder = "No. Handphone"
        addressTF.placeholder = "alamat"
        submit.setTitle("Submit", for: .normal)
        
        namaTF.text = userModel?.name ?? ""
        emailTF.text = userModel?.email ?? ""
        handphoneTF.text = userModel?.phone ?? ""
        addressTF.text = userModel?.address ?? ""
        
        setTextFieldGreen()
        
        setBtn()
        
    }
    
    private func setTextFieldGreen() {
        namaTF.setMainUnderLine()
        emailTF.setMainUnderLine()
        handphoneTF.setMainUnderLine()
        addressTF.setMainUnderLine()
    }
    
    private func setBtn() {
        containerSubmitBtn.addDropShadow(to: .top)
        submit.setButtonMainStyle()
        submit.addTarget(self, action: #selector(submitBtnTapped), for: .touchUpInside)
    }
    
    @objc func submitBtnTapped() {
        presenter?.validateForm(screen: self, userModel: userModel)
    }
}

extension UserEditProfileViewController: UserEditProfileViewProtocol {
    func setTexfieldRed(textfield: UITextField) {
        textfield.setRedUnderLine()
    }
    
    func successEditData(message: String) {
        self.showToast(message: message)
        delay(weakVar: self, deadline: .now() + 1.1) { strongSelf in
            strongSelf.delegate?.refreshPage()
            strongSelf.navigationController?.popViewController(animated: true)
            
        }
    }
    
    /// Show loading
    func showLoading() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            self.spinner = spinner
        }
    }
    
    
    /// remove loading
    func removeLoading() {
        guard let spinner = self.spinner else { return }
        self.removeSpinner(spinner)
    }
    
    // MARK: error handling
    /// Method for handling error response from network threading
    /// - Parameter error: Model Error From network threading
    func errorResponse(error: Error) {
        if let newError = error as? ErrorResponse {
            self.showToast(message: newError.messages)
        }
    }
    
}
