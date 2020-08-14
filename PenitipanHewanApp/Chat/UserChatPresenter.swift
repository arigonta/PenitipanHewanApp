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
    var channelModel: [ChannelModel]? { get set}
    func removeListener()
    func createChannels(_ screen: UserChatViewController, _ petshopId: String)
    func channelListen(_ screen: UserChatViewController, _ currentId: String)
    func handleDocumetnChange(_ change: ChannelModel)
    
    func directToChatDetail(_ screen: UserChatViewController, _ otherId: String)
}

class UserChatPresenter: UserChatPresenterProtocol {
    var view: UserChatViewProtocol?
    var channelListener: ListenerRegistration?
    var channelModel: [ChannelModel]?
    
    // MARK: Injections
    private var currentId = UserDefaultsUtils.shared.getUsername()
    private let firestore = Firestore.firestore()
    private var channelRef: CollectionReference {
        return firestore.collection("channels")
    }
    private var userRef: CollectionReference {
        return firestore.collection("Users")
    }
    
    init(_ view: UserChatViewProtocol) {
        self.view = view
    }
    
    func createChannels(_ screen: UserChatViewController, _ petshopId: String) {
        checkChannels(screen, petshopId)
    }
    
    func channelListen(_ screen: UserChatViewController, _ currentId: String) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.channelListener = self.channelRef.addSnapshotListener({ [weak self] (querySnapshot, error) in
                screen.removeSpinner(spinner)
                
                guard let self = self else { return }
                guard let snapShot = querySnapshot else {
                    print("error: \(error?.localizedDescription ?? "no error")")
                    return
                }
                
                var newModel = [ChannelModel]()
                // looping
                snapShot.documentChanges.forEach {
                    guard let model = ChannelModel(documentChange: $0) else { return }
                    newModel.append(model)
                }
                
                // filter data with currentId
                self.channelModel = newModel.filter({
                    $0.customerId == currentId || $0.petshopId == currentId
                })
                
                guard let channelModel = self.channelModel else { return }
                channelModel.forEach { [weak self] channel in
                    guard let self = self else { return }
                    self.handleDocumetnChange(channel)
                }
            })
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
    func directToChatDetail(_ screen: UserChatViewController, _ otherId: String) {
        UserDefaultsUtils.shared.removePetshopId()
    }
    
}

extension UserChatPresenter {
    private func checkChannels(_ screen: UserChatViewController, _ petshopId: String) {
        screen.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.channelListener = self.channelRef.addSnapshotListener({ [weak self] (querySnapshot, error) in
                screen.removeSpinner(spinner)
                
                guard let self = self else { return }
                guard let snapShot = querySnapshot else {
                    print("error: \(error?.localizedDescription ?? "no error")")
                    return
                }
                
                var newModel = [ChannelModel]()
                // looping
                snapShot.documentChanges.forEach {
                    guard let model = ChannelModel(documentChange: $0) else { return }
                    newModel.append(model)
                }
                
                // filter data with petshopId
                self.channelModel = newModel.filter({
                    $0.petshopId == petshopId
                })
                
                guard let channelModel = self.channelModel else { return }
                if channelModel.isEmpty {
                    self.doCreateChannels(screen, petshopId)
                } else {
                    self.directToChatDetail(screen, petshopId)
                }
            })
        }
    }
    
    private func doCreateChannels(_ screen: UserChatViewController, _ petshopId: String) {
        let channel = ChannelModel(customerId: self.currentId, petshopId: petshopId)
        self.channelRef.addDocument(data: channel.representation) { error in
            if let error = error {
                print("error saving chat: \(error.localizedDescription)")
            } else {
                self.directToChatDetail(screen, petshopId)
            }
        }
    }
}
