//
//  UserProfilePresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol UserProfilePresenterProtocol {
    var view: UserProfileViewProtocol? { get set }
    var cameraHelper: CameraLibraryHelper? { get set }
    var userModel: UserModel? { get set }
    func directToTopUp(_ screen: UserProfileViewController, saldo: Int)
    func directToEditData(_ screen: UserProfileViewController, userModel: UserModel?, delegate: RefreshProfilePageDelegate?)
    func directToChangePassword(_ screen: UserProfileViewController)
    func openAlert(_ screen: UserProfileViewController)
    func getProfileData(_ screen: UserProfileViewController)
}

class UserProfilePresenter: UserProfilePresenterProtocol {
    
    var view: UserProfileViewProtocol?
    var cameraHelper: CameraLibraryHelper?
    var currentID = UserDefaultsUtils.shared.getCurrentId()
    var currentRole = UserDefaultsUtils.shared.getRole()
    var userModel: UserModel?
    
    init(_ view: UserProfileViewProtocol) {
        self.view = view
    }
    
    func directToTopUp(_ screen: UserProfileViewController, saldo: Int) {
        if !currentRole.elementsEqual("petshop") {
            let nextVC = UserProfileAddSaldoViewController(nibName: "UserProfileAddSaldoViewController", bundle: nil)
            nextVC.saldoPrefilled = saldo
            nextVC.hidesBottomBarWhenPushed = true
            screen.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func directToEditData(_ screen: UserProfileViewController, userModel: UserModel?, delegate: RefreshProfilePageDelegate?) {
        let nextVC = UserEditProfileViewController(nibName: "UserEditProfileViewController", bundle: nil)
        nextVC.userModel = userModel
        nextVC.delegate = delegate
        nextVC.hidesBottomBarWhenPushed = true
        screen.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func directToChangePassword(_ screen: UserProfileViewController) {
        let nextVC = UserProfilePasswordViewController(nibName: "UserProfilePasswordViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        screen.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func openAlert(_ screen: UserProfileViewController) {
        var actions = [AlertActionModel]()
        let newAction1 = AlertActionModel("Ambil dari kamera", .default) { (action) in
            self.openCamera(screen)
        }
        let newAction2 = AlertActionModel("Ambil dari Galeri Foto", .default) { (action) in
            self.openGaleri(screen)
        }
        let newAction3 = AlertActionModel("Cancel", .cancel) { (action) in
            screen.dismiss(animated: true, completion: nil)
        }
        actions.append(newAction1)
        actions.append(newAction2)
        actions.append(newAction3)
        let newAlertModel = AlertModel("", "Tetapkan Foto Profil", .actionSheet, actions)
        screen.setAlert(data: newAlertModel)
    }
    
    func getProfileData(_ screen: UserProfileViewController) {
        getData(willSendFirebase: false)
    }
}

extension UserProfilePresenter {
    func openCamera(_ screen: UserProfileViewController) {
        cameraHelper = CameraLibraryHelper(screen, self)
        cameraHelper?.checkAndOpenCamera()
    }
    
    func openGaleri(_ screen: UserProfileViewController) {
        cameraHelper = CameraLibraryHelper(screen, self)
        cameraHelper?.checkAndOpenlibrary()
    }
}

extension UserProfilePresenter: CameraLibraryHelperDelegate {
    func resultCamera(image: UIImage, base64: String) {
        self.userModel?.photo = "data:image/jpeg;base64,\(base64)"
        self.uploadPhotoProfile()
    }
}

// MARK: - API
extension UserProfilePresenter {
    
    /// Method for get data profile
    private func getData(willSendFirebase: Bool) {
        let url = "\(CommonHelper.shared.BASE_URL)user/\(currentID)"
        view?.showLoading()
        NetworkHelper.shared.connect(url: url, params: nil, model: UserAPIModel.self) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.removeLoading()
            
            switch result {
            case .failure(let err):
                self.view?.errorResponse(err)
                
            case .success(let value):
                self.userModel = value.data
                
                if willSendFirebase {
                    self.createUserFirestore(userModel: value.data)
                } else {
                    self.view?.updateScreen(data: value.data)
                }
                
            }
        }
    }
    
    
    /// Method for Upload Image
    private func uploadPhotoProfile() {
        let url = "\(CommonHelper.shared.BASE_URL)user/update"
        view?.showLoading()
        NetworkHelper.shared.connect(url: url, params: userModel?.postForUpdate, model: SuccessPostAPIModel.self) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.removeLoading()
            
            switch result {
            case .failure(let err):
                self.view?.errorResponse(err)
                
            case .success(_ ):
                self.getData(willSendFirebase: true)
            }
        }
    }
    
    // MARK: - FIREBASE
    private func createUserFirestore(userModel: UserModel?) {
        guard let userId = userModel?.id, let dataForFirestore = userModel?.representation else { return }
        let firestore = Firestore.firestore()
        let userCollection = firestore.collection("user").document("\(userId)")
        view?.showLoading()
        userCollection.setData(dataForFirestore) { [weak self] error in
            guard let self = self else { return }
            self.view?.removeLoading()
            
            var isSuccess = false
            if error == nil {
                isSuccess = true
            }
            
            self.view?.updateScreen(data: userModel)
        }
    }
}
