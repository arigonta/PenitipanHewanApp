//
//  UserChatPresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 14/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol UserChatPresenterProtocol: class {
    var view: UserChatViewProtocol? { get set }
    var channelListener: ListenerRegistration? { get set }
    var channelModels: [ChannelModel]? { get set}
    func removeListener()
    func createChannels(_ screen: UserChatViewController, _ petshopId: Int)
    func channelListen(_ screen: UserChatViewController)
    func handleDocumetnChange(_ change: ChannelModel)
    
    func directToChatDetail(_ screen: UserChatViewController, _ channelModel: ChannelModel?)
}

class UserChatPresenter: UserChatPresenterProtocol {
    var view: UserChatViewProtocol?
    var channelListener: ListenerRegistration?
    var channelModels: [ChannelModel]?
    
    // MARK: Injections
    private var currentId = UserDefaultsUtils.shared.getCurrentId()
    private let firestore = Firestore.firestore()
    private var channelRef: CollectionReference {
        return firestore.collection("channels")
    }
    
    init(_ view: UserChatViewProtocol) {
        self.view = view
    }
    
    func createChannels(_ screen: UserChatViewController, _ petshopId: Int) {
        checkChannels(screen, petshopId)
    }
    
    func channelListen(_ screen: UserChatViewController) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.channelWillListen { [weak self] (dataChannel, errorString) in
                screen.removeSpinner(spinner)
                guard let self = self else { return }
                
                if let error = errorString {
                    screen.showToast(message: error)
                    
                } else {
                    
                    self.channelModels = dataChannel
                    
                    // make dataChannel not optional
                    guard let channelModels = self.channelModels else { return }
                    
                    // looping and update data to view
                    channelModels.forEach { [weak self] channel in
                        guard let self = self else { return }
                        self.willGetUserDocument(channel)
                    }
                }
            }
        }
        
    }
    
    func handleDocumetnChange(_ channel: ChannelModel) {
        guard let change = channel.documentChange else { return }
        switch change.type {
        case .added:
            view?.addChannelToTable(channel)
        case .modified:
            view?.updateChannelInTable(channel)
        case .removed:
            view?.removeChannelFromTable(channel)
        }
    }
    
    func removeListener() {
        channelListener?.remove()
    }
    
    // MARK: - direct
    func directToChatDetail(_ screen: UserChatViewController, _ channelModel: ChannelModel?) {
        let nextVC = ChatDetailViewController(channelModel)
        screen.navigationController?.pushViewController(nextVC, animated: true)
        UserDefaultsUtils.shared.removePetshopId()
    }
    
}

extension UserChatPresenter {
    private func checkChannels(_ screen: UserChatViewController, _ petshopId: Int) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.channelWillListen { [weak self] (dataChannel, errorString) in
                screen.removeSpinner(spinner)
                guard let self = self else { return }
                
                if let error = errorString {
                    screen.showToast(message: error)
                } else {
                    // make dataChannel not optional
                    guard let dataChannel = dataChannel else { return }
                    // filter dataChannel with petShopId
                    self.channelModels = dataChannel.filter { $0.petshopId == petshopId }
                    
                    guard
                        let newChannellModel = self.channelModels,
                        !newChannellModel.isEmpty
                    else {
                        self.doCreateChannels(screen, petshopId)
                        return
                    }
                    self.directToChatDetail(screen, newChannellModel.first)
                }
            }
        }
    }
    
    private func doCreateChannels(_ screen: UserChatViewController, _ petshopId: Int) {
        let channel = ChannelModel(customerId: self.currentId, petshopId: petshopId)
        self.channelRef.addDocument(data: channel.representation) { error in
            if let error = error {
                print("error saving chat: \(error.localizedDescription)")
            }
        }
    }
    
    // base channel listener
    private func channelWillListen(completion: (([ChannelModel]?, String?) -> Void)? = nil) {
        self.channelListener = self.channelRef.addSnapshotListener({ (querySnapshot, error) in
            let stringError = "gagal mendapatkan data"
            
            if error != nil {
                completion?(nil, stringError)
                
            } else {
                var newModel = [ChannelModel]()
                
                // make querySnapshot strong
                guard let snapShot = querySnapshot else {
                    completion?(nil, stringError)
                    return
                }
                
                // looping
                snapShot.documentChanges.forEach {
                    guard let model = ChannelModel(documentChange: $0) else { return }
                    newModel.append(model)
                }
                
                // filter new model only have 'curentID'
                let modelFilter = newModel.filter { $0.petshopId == self.currentId || $0.customerId == self.currentId }
                
                completion?(modelFilter, nil)
            }
        })
    }
    
    private func willGetUserDocument(_ channel: ChannelModel) {
        var newChannel = channel
        let targetId = newChannel.customerId == currentId ? newChannel.petshopId : newChannel.customerId
    
        let docRef = firestore.collection("user").document("\(targetId)")
        docRef.getDocument { (documentSnapshot, error) in
            
            guard
                let data = documentSnapshot?.data(),
                let targetName = data["name"] as? String
            else {
                return
            }
            
            newChannel.customerName = ""
            newChannel.petshopName = ""
            
            newChannel.petshopPhoto = ""
            newChannel.customerPhoto = ""
            
            let photoGet = data["photo"] as? String ?? ""
            
            if targetId == channel.customerId {
                newChannel.customerName = targetName
                newChannel.customerPhoto = photoGet
            } else {
                newChannel.petshopName = targetName
                newChannel.petshopPhoto = photoGet
            }
            
            self.handleDocumetnChange(newChannel)
        }
    }
}
