//
//  UserPetshopDetailPresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 17/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol UserPetshopDetailPresenterProtocol {
    var view: UserPetshopDetailViewProtocol? { get set }
    var currentUserModel: UserModel? { get set }
    var petshopModel: UserModel? { get set }
    func getDetailPetshop(_ screen: UserPetshopDetailViewController, _ petshopId: Int)
    func directToChat(_ screen: UserPetshopDetailViewController)
    func directToReservationForm(_ screen: UserPetshopDetailViewController)
}

class UserPetshopDetailPresenter: UserPetshopDetailPresenterProtocol {
    var view: UserPetshopDetailViewProtocol?
    var currentUserModel: UserModel?
    var petshopModel: UserModel?
    
    init(view: UserPetshopDetailViewProtocol) {
        self.view = view
    }
    
    func getDetailPetshop(_ screen: UserPetshopDetailViewController, _ petshopId: Int) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest(userId: petshopId) { [weak self] (dataPetshop, error) in
                guard let self = self else { return }
                screen.removeSpinner(spinner)
                
                if error != nil {
                    screen.showToast(message: "gagal Mendapatkan Data")
                } else {
                    
                    guard let dataPetshop = dataPetshop else {
                        screen.showToast(message: "gagal Mendapatkan Data")
                        return
                    }
                    self.petshopModel = dataPetshop
                    self.view?.updateScreen(petshopData: dataPetshop)
                }
            }
        }
    }
    
    func directToChat(_ screen: UserPetshopDetailViewController) {
        guard let petshopId = self.petshopModel?.id else {
            screen.showToast(message: "gagal memproses data")
            return
        }
        getCurrentUserModel(screen, petshopId)
    }
    
    func directToReservationForm(_ screen: UserPetshopDetailViewController) {
        let nextVC = UserReservationFormViewController(nibName: "UserReservationFormViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        screen.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - go to chat
extension UserPetshopDetailPresenter {
    private func getCurrentUserModel(_ screen: UserPetshopDetailViewController, _ petshopId: Int) {
        let currentId = UserDefaultsUtils.shared.getCurrentId()
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest(userId: currentId) { [weak self] (userModel, error) in
                guard let self = self else { return }
                
                
                if error != nil {
                    screen.removeSpinner(spinner)
                    screen.showToast(message: "gagal Mendapatkan Data")
                } else {
                    
                    guard let userModel = userModel else {
                        screen.removeSpinner(spinner)
                        screen.showToast(message: "gagal Mendapatkan Data")
                        return
                    }
                    self.currentUserModel = userModel
                    self.createUserCustomerAndPetshop(screen, spinner, petshopId)
                }
            }
        }
    }
    
    private func createUserCustomerAndPetshop(_ screen: UserPetshopDetailViewController, _ spinner: UIView, _ petshopId: Int) {
        createUserFirestore(userModel: petshopModel) { (successCreatePetshop) in
            if !successCreatePetshop {
                screen.removeSpinner(spinner)
                screen.showToast(message: "gagal memproses data")
                
            } else {
                self.createUserFirestore(userModel: self.currentUserModel) { (successCreateCustomer) in
                    screen.removeSpinner(spinner)
                    
                    if !successCreateCustomer {
                        screen.showToast(message: "gagal memproses data")
                    } else {
                       self.directToChatScreen(screen, petshopId)
                    }
                }
            }
        }
    }
    private func directToChatScreen(_ screen: UserPetshopDetailViewController, _ petshopId: Int) {
        UserDefaultsUtils.shared.setPetshopId(value: petshopId)
        screen.navigationController?.tabBarController?.selectedIndex = 2
        screen.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - API
extension UserPetshopDetailPresenter {
    
    private func sendRequest(userId: Int, completion: ((UserModel?, Error?) -> Void)? = nil) {
        
        let url = "\(CommonHelper.shared.BASE_URL)user/\(userId)"
        NetworkHelper.shared.connect(url: url, params: nil, model: UserAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    private func createUserFirestore(userModel: UserModel?, completion: ((Bool) -> Void)? = nil) {
        guard let userId = userModel?.id, let dataForFirestore = userModel?.representation else { return }
        let firestore = Firestore.firestore()
        let userCollection = firestore.collection("user").document("\(userId)")
        userCollection.setData(dataForFirestore) { error in
            var isSuccess = false
            if error == nil {
                isSuccess = true
            }
            completion?(isSuccess)
        }
    }
}
