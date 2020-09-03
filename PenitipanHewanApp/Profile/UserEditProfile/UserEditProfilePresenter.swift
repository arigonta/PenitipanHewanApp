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
        
        let url = "\(CommonHelper.shared.BASE_URL)user/update"
        
        view?.showLoading()
        NetworkHelper.shared.connect(url: url, params: dataPost.postForUpdate, model: SuccessPostAPIModel.self) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure(let err):
                self.view?.removeLoading()
                self.view?.errorResponse(error: err)
                
            case .success(let value):
                let message = value.messages.first ?? "Success Memperbarui Data"
                self.createUserFirestore(screen: screen, userModel: dataPost, messageSuccess: message)
            }
        }
    }
    
}

// MARK: - FIREBASE
extension UserEditProfilePresenter {
    private func createUserFirestore(screen: UserEditProfileViewController, userModel: UserModel?, messageSuccess: String) {
        guard let userId = userModel?.id, let dataForFirestore = userModel?.representation else { return }
        let firestore = Firestore.firestore()
        let userCollection = firestore.collection("user").document("\(userId)")
        
        userCollection.setData(dataForFirestore) { [weak self] error in
            guard let self = self else { return }
            self.view?.removeLoading()
            
            var isSuccess = false
            if error == nil {
                isSuccess = true
            }
            
            if !isSuccess {
                screen.showToast(message: "Terjadi kesalahan sistem, mohon coba kembali")
            } else {
                self.view?.successEditData(message: messageSuccess)
            }
        }
    }
}
