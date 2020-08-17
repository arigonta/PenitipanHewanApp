//
//  UserHomePresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 17/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

protocol UserHomePresenterProtocol: class {
    var view: UserHomeViewProtocol? { get set }
    var animalType: [ReferenceAnimalModel]? { get set }
    func getReferenceAnimalType(_ screen: UserHomeViewController)
    func checkData(_ screen: UserHomeViewController, _ animal: String)
}

class UserHomePresenter: UserHomePresenterProtocol {
    var view: UserHomeViewProtocol?
    var animalType: [ReferenceAnimalModel]?
    
    init(_ view: UserHomeViewProtocol) {
        self.view = view
    }
    
    func getReferenceAnimalType(_ screen: UserHomeViewController) {
        getData(screen)
    }
    
    func checkData(_ screen: UserHomeViewController, _ animal: String) {
        guard let dataList = animalType else {
            screen.showToast(message: "data tidak ditemukan")
            return
        }
        
        // filter and get first index
        let newModel = dataList.filter {
            ($0.animal_name ?? "").contains(animal)
        }.first
        
        // check if data not nil
        guard newModel != nil else {
            screen.showToast(message: "data tidak ditemukan")
            return
        }
        
        directToPetShoplist(screen, newModel)
    }
}

// MARK: - DIRECTION
extension UserHomePresenter {
    private func directToPetShoplist(_ screen: UserHomeViewController, _ animalType: ReferenceAnimalModel?) {
        let nextVC = UserPetshopViewController(nibName: "UserPetshopViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.animalType = animalType
        screen.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - API
extension UserHomePresenter {
    private func getData(_ screen: UserHomeViewController) {
        screen.showSpinner { [weak self] spinner in
            guard let self = self else { return }
            
            self.sendRequest { [weak self] (dataList, error) in
                guard let self = self else { return }
                
                screen.removeSpinner(spinner)
                if error != nil {
                    screen.showToast(message: "gagal mendapatkan data")
                } else {
                    self.handleSuccessGetAnimalList(screen, dataList)
                }
            }
        }
    }
    
    private func sendRequest(completion: (([ReferenceAnimalModel]?, Error?) -> Void)? = nil) {
        let url = "\(CommonHelper.shared.BASE_URL)animal/list"
        
        NetworkHelper.shared.connect(url: url, params: nil, model: ReferenceAnimalAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    private func handleSuccessGetAnimalList(_ screen: UserHomeViewController, _ data: [ReferenceAnimalModel]?) {
        guard let dataList = data, !dataList.isEmpty else {
            screen.showToast(message: "gagal mendapatkan data")
            return
        }
        self.animalType = dataList
    }
}
