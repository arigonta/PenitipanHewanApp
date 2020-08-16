//
//  ChannelsModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 14/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import FirebaseFirestore

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

struct ChannelModel {
    let id: String?
    let customerId: String
    let petshopId: String
    var lastMessage: String = ""
    var lastMessageCreated: Date
    let documentChange: DocumentChange?
    
    init(customerId: String, petshopId: String) {
        id = nil
        self.customerId = customerId
        self.petshopId = petshopId
        documentChange = nil
        lastMessageCreated = Date()
    }
    
    init?(documentChange: DocumentChange) {
        let data = documentChange.document.data()
        
        guard
            let customerId = data["customerId"] as? String,
            let petshopId = data["petshopId"] as? String
        else {
            return nil
        }
        
        if let lastMessage = data["lastMessage"] as? String, let sentDate = data["lastMessageCreated"] as? Timestamp {
            self.lastMessage = lastMessage
            self.lastMessageCreated = sentDate.dateValue()
        } else {
            self.lastMessageCreated = Date()
        }
        
        id = documentChange.document.documentID
        self.customerId = customerId
        self.petshopId = petshopId
        self.documentChange = documentChange
        
    }
}

extension ChannelModel: DatabaseRepresentation {
    var representation: [String: Any] {
        var rep: [String: Any] = ["customerId": customerId,
                                  "petshopId": petshopId,
                                  "lastMessageCreated": Date(),
                                  "lastMessage": lastMessage]
        
        if let id = id {
            rep["id"] = id
        }
        return rep
    }
}

extension ChannelModel: Comparable {
    
    static func == (lhs: ChannelModel, rhs: ChannelModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: ChannelModel, rhs: ChannelModel) -> Bool {
        return lhs.customerId < rhs.customerId && lhs.petshopId < rhs.petshopId
    }
    
}