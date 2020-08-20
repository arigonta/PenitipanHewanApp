//
//  CommonModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

// MARK: MODEL ALERT
open class AlertModel {
    var title: String?
    var subtitle: String?
    var style: UIAlertController.Style = .alert
    var actions: [AlertActionModel]?
    
    init(_ title: String, _ subtitle: String, _ style: UIAlertController.Style, _ actions: [AlertActionModel]) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.actions = actions
    }
}

open class AlertActionModel {
    var title: String?
    var style: UIAlertAction.Style = .default
    var onclick: ((UIAlertAction) -> Void)?
    init(_ title: String, _ style: UIAlertAction.Style, _ handler: ((UIAlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.onclick = handler
    }
}

class MainResponse: Codable {
    var code: Int?
    var status: String?
}


// MARK: - user model

struct UserAPIModel: Codable {
    let data: UserModel
}

struct UserModel: Codable {
    let id          : Int?
    let username    : String?
    let password    : String?
    let role        : String?
    let email       : String?
    let name        : String?
    let saldo       : Int?
    let photo       : String?
    let address     : String?
    let phone       : String?
    
    init(username: String? = nil,
         password: String? = nil,
         role: String? = nil,
         email: String? = nil,
         id: Int? = nil,
         name: String? = nil,
         saldo: Int? = nil,
         photo: String? = nil,
         address: String? = nil,
         phone: String? = nil) {
        
        self.username = username
        self.password = password
        self.role = role
        self.email = email
        self.id = id
        self.address = address
        self.name = name
        self.saldo = saldo
        self.photo = photo
        self.phone = phone
    }
}

extension UserModel: DatabaseRepresentation {
    var representation: [String: Any] {
        let rep: [String: Any] = ["name": name ?? "",
                                  "phone": phone ?? "",
                                  "address": address ?? "",
                                  "photo": photo ?? ""]
        return rep
    }
}

class ErrorResponse: Codable, Error {
    let code: Int
    let status: String
    let messages: String
    
    init(code: Int?, status: String?, message: String) {
        self.code = code ?? -1
        self.status = status ?? "failed get info"
        self.messages = message ?? "Terjadi kesalahan sistem, mohon coba kembali"
    }
}
