//
//  UserProfileSaldoCell.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserProfileSaldoCell: UITableViewCell {

    @IBOutlet weak var saldoTft: UILabel!
    @IBOutlet weak var isiSaldoLbl: UILabel!
    
    var currentRole = UserDefaultsUtils.shared.getRole()
    
    func setCell(user: UserModel?) {
        saldoTft.text = "\(user?.saldo ?? 0)".currencyInputFormatting()
        isiSaldoLbl.isHidden = currentRole.elementsEqual("petshop") ? true : false
        self.accessoryType = currentRole.elementsEqual("petshop") ? .none : .disclosureIndicator
        self.selectionStyle = .none
    }
    
}
