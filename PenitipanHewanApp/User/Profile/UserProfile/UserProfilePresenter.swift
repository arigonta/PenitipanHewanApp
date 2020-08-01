//
//  UserProfilePresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

protocol UserProfilePresenterProtocol {
    var view: UserProfileViewProtocol? { get set }
    var cameraHelper: CameraLibraryHelper? { get set }
    func directToTopUp(_ screen: UserProfileViewController)
    func directToEditData(_ screen: UserProfileViewController)
    func directToChangePassword(_ screen: UserProfileViewController)
    func openAlert(_ screen: UserProfileViewController)
    func openCamera(_ screen: UserProfileViewController)
    func openGaleri(_ screen: UserProfileViewController)
}

class UserProfilePresenter: UserProfilePresenterProtocol {
    
    var view: UserProfileViewProtocol?
    var cameraHelper: CameraLibraryHelper?
    
    init(_ view: UserProfileViewProtocol) {
        self.view = view
    }
    
    func directToTopUp(_ screen: UserProfileViewController) {
        let nextVC = UserProfileAddSaldoViewController(nibName: "UserProfileAddSaldoViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        screen.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func directToEditData(_ screen: UserProfileViewController) {
        let nextVC = UserEditProfileViewController(nibName: "UserEditProfileViewController", bundle: nil)
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
        print(image.size)
        print(base64.count)
        view?.updateImage(image: image)
    }
}
