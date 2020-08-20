//
//  AddReservationModel.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 21/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

struct AddReservationAPIModel: Codable {
    let messages: [String]
    let data: AddReservationModel
}

struct AddReservationModel: Codable {
    let petshop_id      : Int?
    let package_name    : String?
    let deskripsi       : String?
    let animal_id       : Int?
    let duration        : Int?
    let price           : Int?
    
    init(petshop_id: Int?, package_name: String?, deskripsi: String?, animal_id: Int?, duration: Int?, price: Int?) {
        self.petshop_id = petshop_id
        self.package_name = package_name
        self.deskripsi = deskripsi
        self.animal_id = animal_id
        self.duration = duration
        self.price = price
    }
}
extension AddReservationModel: DatabaseRepresentation {
    var representation: [String: Any] {
        guard
            let petshop_id = petshop_id,
            let package_name = package_name,
            let animal_id = animal_id,
            let duration = duration,
            let price = price
        else {
            return [String: Any]()
        }
        
        let rep: [String: Any] = ["petshop_id": petshop_id,
                                  "package_name": package_name,
                                  "deskripsi": deskripsi ?? "",
                                  "animal_id": animal_id,
                                  "duration": duration,
                                  "price": price ]
        return rep
    }
}
