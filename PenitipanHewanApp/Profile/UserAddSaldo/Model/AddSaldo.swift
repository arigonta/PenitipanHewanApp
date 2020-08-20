//
//  AddSaldo.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 21/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

struct AddSaldo: Codable {
    var id              : Int?
    var top_up_saldo    : Int?
    
    init(id: Int?, top_up_saldo: Int?) {
        self.id = id
        self.top_up_saldo = top_up_saldo
    }
}

extension AddSaldo: DatabaseRepresentation {
    var representation: [String: Any] {
        let rep: [String: Any] = ["id": id ?? 0,
                                  "top_up_saldo": top_up_saldo ?? 0 ]
        return rep
    }
}
