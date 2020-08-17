//
//  UserPetshopPresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 17/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

protocol UserPetshopPresenterProtocol: class {
    var view: UserPetshopViewProtocol? { get set }
    var dataList: [PetShopListModel]? { get set }
    var currentAnimal: ReferenceAnimalModel? { get set }
    func getListData(_ screen: UserPetshopViewController)
}

class UserPetshopPresenter: UserPetshopPresenterProtocol {
    var view: UserPetshopViewProtocol?
    var dataList: [PetShopListModel]?
    var currentAnimal: ReferenceAnimalModel?
    
    init(_ view: UserPetshopViewProtocol, _ currentAnimal: ReferenceAnimalModel?) {
        self.view = view
        self.currentAnimal = currentAnimal
    }
    
    func getListData(_ screen: UserPetshopViewController) {
        getData(screen)
    }
}

// MARK: - API
extension UserPetshopPresenter {
    private func getData(_ screen: UserPetshopViewController) {
        guard
        let currentAnimal = self.currentAnimal,
        let animalId = currentAnimal.animal_id else { return }
        
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest(animalId: animalId) { [weak self] (dataList, error) in
                guard let self = self else { return }
                
                screen.removeSpinner(spinner)
                if error != nil {
                    screen.showToast(message: "gagal mendapatkan data")
                } else {
                    self.handleSuccessGetData(screen, dataList)
                }
            }
        }
    }
    private func sendRequest(animalId: Int, completion: (([PetShopListModel]?, Error?) -> Void)? = nil) {
        
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/list?animal_id=\(animalId)&petshop_id="
        
        NetworkHelper.shared.connect(url: url, params: nil, model: PetShopListAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    private func handleSuccessGetData(_ screen: UserPetshopViewController, _ data: [PetShopListModel]?) {
        guard let dataList = data else {
            screen.showToast(message: "gagal mendapatkan data")
            return
        }
        
        view?.updateScreen(dataList)
        
    }
}
