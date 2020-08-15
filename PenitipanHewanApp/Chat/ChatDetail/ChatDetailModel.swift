//
//  ChatDetailModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 15/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
    
    let id: String?
    let content: String
    let sentDate: Date
    let sender: SenderType
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    // di init kalo pas mau save data
    init(currentUserName: String, content: String, displayName: String) {
        sender = SenderModel(currentUserName, displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    // data dari firebase
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = sentDate.dateValue()
        sender = SenderModel(senderID, senderName)
        
        if let content = data["content"] as? String {
            self.content = content
        } else {
            self.content = ""
        }
    }
    
}

// untuk upload data
extension Message: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
        rep["content"] = content
        
        return rep
    }
    
}

extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}

class SenderModel: SenderType {
    var senderId: String
    var displayName: String
    
    init(_ id: String, _ displayName: String) {
        self.senderId = id
        self.displayName = displayName
    }
}
