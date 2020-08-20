//
//  Login.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 28/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

struct loginAPIModel: Codable {
    let messages: String
    let data: LoginModel
}

struct LoginModel: Codable {
    let id          : Int?
    let username    : String?
    let password    : String?
    let role        : String?
    let email       : String?
    
    init(username: String? = nil, password: String? = nil, role: String? = nil, email: String? = nil, id: Int? = nil) {
        self.username = username
        self.password = password
        self.role = role
        self.email = email
        self.id = id
    }
}
