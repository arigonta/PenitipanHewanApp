//
//  ReferenceAnimalModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 17/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

struct ReferenceAnimalAPIModel: Codable {
    let data: [ReferenceAnimalModel]
}

struct ReferenceAnimalModel: Codable {
    var animal_name        : String?
    var animal_id          : Int?
    
    init(animal_name: String?, animal_id: Int?) {
        self.animal_name = animal_name
        self.animal_id = animal_id
    }
}
