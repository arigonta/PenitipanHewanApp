//
//  PetshopProfilePresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

protocol PetshopProfilePresenterProtocol {
    var view: PetshopProfileViewProtocol? { get set }
    var cameraHelper: CameraLibraryHelper? { get set }
    func directToEditData(_ screen: PetshopProfileViewController)
    func directToChangePassword(_ screen: PetshopProfileViewController)
    func openAlert(_ screen: PetshopProfileViewController)
    func openCamera(_ screen: PetshopProfileViewController)
    func openGaleri(_ screen: PetshopProfileViewController)
}

class PetshopProfilePresenter: PetshopProfilePresenterProtocol {
    
    var view: PetshopProfileViewProtocol?
    var cameraHelper: CameraLibraryHelper?
    init(_ view: PetshopProfileViewProtocol) {
        self.view = view
    }
    
    func directToEditData(_ screen: PetshopProfileViewController) {
        let nextVC = UserEditProfileViewController(nibName: "UserEditProfileViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        screen.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func directToChangePassword(_ screen: PetshopProfileViewController) {
        let nextVC = UserProfilePasswordViewController(nibName: "UserProfilePasswordViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        screen.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func openAlert(_ screen: PetshopProfileViewController) {
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
    
    func openCamera(_ screen: PetshopProfileViewController) {
        cameraHelper = CameraLibraryHelper(screen, self)
        cameraHelper?.checkAndOpenCamera()
    }
    
    func openGaleri(_ screen: PetshopProfileViewController) {
        cameraHelper = CameraLibraryHelper(screen, self)
        cameraHelper?.checkAndOpenlibrary()
    }
}

extension PetshopProfilePresenter: CameraLibraryHelperDelegate {
    func resultCamera(image: UIImage, base64: String) {
        print(image.size)
        print(base64.count)
        view?.updateImage(image: image)
    }
    
    
}

