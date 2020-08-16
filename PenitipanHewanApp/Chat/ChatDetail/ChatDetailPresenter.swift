//
//  ChatDetailPresenter.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 15/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import Firebase
import UIKit

protocol ChatDetailPresenterProtocol: class {
    var view: ChatDetailViewProtocol? { get set }
    var messageListener: ListenerRegistration? { get set }
    var channelModel: ChannelModel? { get set }
    var messages: [Message]? { get set }
    func messageListnerObserv(_ screen: ChatDetailViewController)
    func save(_ screen: ChatDetailViewController, _ message: Message)
    func removeListener()
}

class ChatDetailPresenter: ChatDetailPresenterProtocol {
    var view: ChatDetailViewProtocol?
    var messageListener: ListenerRegistration?
    var channelModel: ChannelModel?
    var messages: [Message]?
    
    // MARK: Injection
    private let firestore = Firestore.firestore()
    private var reference: CollectionReference?
    private var channelRef: CollectionReference?
    
    init(_ view: ChatDetailViewProtocol?, _ channelModel: ChannelModel?) {
        self.view = view
        self.channelModel = channelModel
    }
    
    func messageListnerObserv(_ screen: ChatDetailViewController) {
        guard let channelId = channelModel?.id else { return }
        reference = firestore.collection(["channels", channelId, "thread"].joined(separator: "/"))
        
        screen.showSpinner { [weak self] spinner in
            guard let self = self else { return }
            
            self.messageListener = self.reference?.addSnapshotListener({ [weak self] (querySnapshot, error) in
                screen.removeSpinner(spinner)
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.handleSuccessListener(querySnapshot)
                }
            })
        }
        
    }
    
    func save(_ screen: ChatDetailViewController, _ message: Message) {
        guard let channelId = channelModel?.id else { return }
        reference = firestore.collection(["channels", channelId, "thread"].joined(separator: "/"))
        reference?.addDocument(data: message.representation) { error in
            if error != nil {
                screen.showToast(message: "gagal mengirim pesan")
                return
            } else {
                // every save new chat, will update channel with last message
                self.updateChannel(channelId, message)
            }
        }
    }
    
    func removeListener() {
        self.messageListener?.remove()
    }
}

extension ChatDetailPresenter {
    private func handleSuccessListener(_ querySnapshot: QuerySnapshot?) {
        guard let snapshot = querySnapshot else {
            print("error from snapshot")
            return
        }
        snapshot.documentChanges.forEach { (documentChange) in
            self.handleDocumentChange(documentChange)
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else { return }
        switch change.type {
        case .added:
            view?.insertMessage(message)
        case .removed:
            view?.deleteMessage(message)
        default:
            break
        }
    }
    
    private func updateChannel(_ channelId: String ,_ message: Message) {
        let param: [String: Any] = ["lastMessage": message.content,
                                    "lastMessageCreated": message.sentDate]
        firestore.collection("channels").document(channelId).updateData(param) { error in
            if error != nil {
                print("error update last message to channel")
            }
            
            self.view?.successSendMessage()
        }
    }
}
