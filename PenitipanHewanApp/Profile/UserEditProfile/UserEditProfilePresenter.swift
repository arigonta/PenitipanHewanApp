//
//  UserEditProfilePresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 21/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Kingfisher

protocol UserEditProfilePresenterProtocol: class {
    var view: UserEditProfileViewProtocol? { get set }
    func validateForm(screen: UserEditProfileViewController, userModel: UserModel?)
}

class UserEditProfilePresenter: UserEditProfilePresenterProtocol {
    var view: UserEditProfileViewProtocol?
    
    var currentRole = UserDefaultsUtils.shared.getRole()
    
    init(view: UserEditProfileViewProtocol) {
        self.view = view
    }
    
    func validateForm(screen: UserEditProfileViewController, userModel: UserModel?) {
        
        let nameTF = screen.namaTF!
        let emailTF = screen.emailTF!
        let phoneTF = screen.handphoneTF!
        let addressTF = screen.addressTF!
        
        var isNameValidate = false
        var isEmailValidate = false
        var isPhoneValidate = false
        var isAddressValidatte = true
        
        if emailTF.text == "" || emailTF.text?.isValidEmail == false {
            view?.setTexfieldRed(textfield: emailTF)
            isEmailValidate = false
        } else {
            isEmailValidate = true
        }
        
        if phoneTF.text == "" {
            view?.setTexfieldRed(textfield: phoneTF)
            isPhoneValidate = false
        } else {
            isPhoneValidate = true
        }
        
        if nameTF.text == "" {
            view?.setTexfieldRed(textfield: nameTF)
            isNameValidate = false
        } else {
            isNameValidate = true
        }
        
        if addressTF.text == "" {
            view?.setTexfieldRed(textfield: addressTF)
            isAddressValidatte = false
        } else {
            isAddressValidatte = true
        }
        
        if isNameValidate && isEmailValidate && isPhoneValidate && isAddressValidatte {
            guard var newUserModel = userModel else { return }
            newUserModel.address = addressTF.text ?? ""
            newUserModel.email = emailTF.text ?? ""
            newUserModel.phone = phoneTF.text ?? ""
            newUserModel.name = nameTF.text ?? ""
//            newUserModel.photo = getBase64(userModel: userModel)
            postData(screen, dataPost: newUserModel)
        }
        
    }
    
    private func getBase64(userModel: UserModel?) -> String {
        if let photo = userModel?.photo, !photo.isEmpty {
            let newImageView: UIImageView = .init()
            let url = URL(string: photo)
            newImageView.kf.setImage(with: url)
            
            let data = newImageView.image?.jpegData(compressionQuality: 0.2)
            let base64 = data?.base64EncodedString() ?? ""
            let returnString = !base64.isEmpty ? "data:image/jpeg;base64,\(base64)" : ""
            return returnString
        } else {
            return ""
        }
        
    }
}

// MARK: - API
extension UserEditProfilePresenter {
    private func postData(_ screen: UserEditProfileViewController, dataPost: UserModel) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest(dataPost) { (dataSuccess, error) in
                
                if let newError = error as? ErrorResponse {
                    let message = newError.messages
                    screen.showToast(message: message)
                } else {
                    
                    guard let newDataSuccess = dataSuccess else { return }
                    let message = newDataSuccess.messages.first ?? "Success Update data"
                    self.createUserFirestore(screen: screen, spinner: spinner, userModel: dataPost, messageSuccess: message)
                }
            }
        }
        
    }
    private func sendRequest(_ dataPost: UserModel, completion: ((SuccessPostAPIModel?, Error?) -> Void)? = nil) {
        
        let url = "\(CommonHelper.shared.BASE_URL)user/update"
        NetworkHelper.shared.connect(url: url, params: dataPost.postForUpdate, model: SuccessPostAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value, nil)
            }
        }
    }
    
    
}

// MARK: - FIREBASE
extension UserEditProfilePresenter {
    private func createUserFirestore(screen: UserEditProfileViewController, spinner: UIView, userModel: UserModel?, messageSuccess: String) {
        guard let userId = userModel?.id, let dataForFirestore = userModel?.representation else { return }
        let firestore = Firestore.firestore()
        let userCollection = firestore.collection("user").document("\(userId)")
        userCollection.setData(dataForFirestore) { error in
            var isSuccess = false
            if error == nil {
                isSuccess = true
            }
            
            screen.removeSpinner(spinner)
            if !isSuccess {
                screen.showToast(message: "Terjadi kesalahan sistem, mohon coba kembali")
            } else {
                screen.showToast(message: messageSuccess)
                delay(deadline: .now() + 0.55) {
                    screen.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
