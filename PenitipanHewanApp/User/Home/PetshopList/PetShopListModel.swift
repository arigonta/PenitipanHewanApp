//
//  PetShopListModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 17/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

struct PetShopListAPIModel: Codable {
    let messages: [String]
    let data: [PetShopListModel]
}

struct PetShopListModel: Codable {
    var petshop_package_id  : Int?
    var photo               : String?
    var petshop_name        : String?
    var petshop_id          : Int?
    var petshop_address     : String?
    var package_name        : String?
    var animal_name         : String?
    var deskripsi           : String?
    var price               : Int?
    var duration            : Int?
    var status              : Int?
    
    init(petshop_package_id: Int? = nil,
         photo: String? = nil,
         petshop_name: String? = nil,
         petshop_id: Int? = nil,
         package_name: String? = nil,
         animal_name: String? = nil,
         deskripsi: String? = nil,
         price: Int? = nil,
         duration: Int? = nil,
         status: Int? = nil,
         petshop_address: String? = nil) {
        
        self.petshop_package_id = petshop_package_id
        self.photo = photo
        self.petshop_name = petshop_name
        self.petshop_id = petshop_id
        self.animal_name = animal_name
        self.deskripsi = deskripsi
        self.price = price
        self.duration = duration
        self.status = status
        self.petshop_address = petshop_address
    }
}
