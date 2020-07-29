//
//  UserPetshopCell.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserPetshopCell: UITableViewCell {

    @IBOutlet weak var petshopImgView: UIImageView!
    @IBOutlet weak var paketLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    func setCell() {
        petshopImgView.image = #imageLiteral(resourceName: "Kucing")
        paketLbl.text = "ini nama paket"
        addressLbl.text = "alamat jalanin aja dulu yang penting ketemu kan, gapapa g"
    }
    
}
