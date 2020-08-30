//
//  ReservationModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 19/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

struct ReservationAPIModel: Codable {
    let messages: [String]
    let data: ReservationModel
}

struct ReservationModel: Codable {
    var petshop_package_id  : Int?
    var user_id             : Int?
    var animal_name         : String?
    var animal_racial       : String?
    var age                 : Int?
    var color               : String?
    var is_vaccine          : Bool?
    var last_time_got_sick  : String?
    var note                : String?
    var animal_photo        : String?
    
    init(petshop_package_id: Int?,
         user_id: Int?,
         animal_name: String?,
         animal_racial: String?,
         age: Int?,
         color: String?,
         is_vaccine: Bool?,
         last_time_got_sick: String?,
         note: String?, photo: String?) {
        
        self.petshop_package_id = petshop_package_id
        self.user_id = user_id
        self.animal_name = animal_name
        self.animal_racial = animal_racial
        self.age = age
        self.color = color
        self.is_vaccine = is_vaccine
        self.last_time_got_sick = last_time_got_sick
        self.note = note
        self.animal_photo = photo
    }
}

extension ReservationModel: DatabaseRepresentation {
    var representation: [String: Any] {
        guard
            let userId = user_id,
            let packageId = petshop_package_id,
            let animalName = animal_name,
            let animalRacial = animal_racial,
            let age = age,
            let color = color,
            let photo = animal_photo
        else {
            return [String: Any]()
        }
        
        let rep: [String: Any] = ["petshop_package_id": packageId,
                                  "user_id": userId,
                                  "animal_name": animalName,
                                  "animal_racial": animalRacial,
                                  "age": age,
                                  "color": color,
                                  "is_vaccine": is_vaccine ?? false,
                                  "last_time_got_sick": last_time_got_sick ?? "Belum pernah sakit",
                                  "note": note ?? "", "animal_photo": photo]
        return rep
    }
}
