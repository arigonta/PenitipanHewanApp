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
    @IBOutlet weak var pricePackageLbl: UILabel!
    
    func setCell(data: PetShopListModel?) {
        guard let data = data else { return }
        petshopImgView.image = #imageLiteral(resourceName: "defaultEmptyPhoto")
        paketLbl.text = "\(data.petshop_name ?? "") - \(data.duration ?? 0) hari"
        addressLbl.text = data.petshop_address ?? "alamat kosong"
        pricePackageLbl.text = "\(data.price ?? 0)".currencyInputFormatting()
    }
    
}
