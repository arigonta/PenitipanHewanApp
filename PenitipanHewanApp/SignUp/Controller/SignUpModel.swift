//
//  SignUpModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 10/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

struct SignUpAPIModel: Codable {
    let data: SignUpModel
}

struct SignUpModel: Codable {
    var username    : String?
    var name        : String?
    var password    : String?
    var role        : String?
    var email       : String?
    var phone       : String?
    var address     : String?
    
    init(_ username: String?, _ password: String?, _ role: String?, _ email: String?, _ name: String?, _ phone: String?, _ address: String?) {
        self.username = username
        self.password = password
        self.role = role
        self.email = email
        self.name = name
        self.phone = phone
        self.address = address
    }
}
