//
//  UserPetshopCell.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import Kingfisher

class UserPetshopCell: UITableViewCell {

    @IBOutlet weak var petshopImgView: UIImageView!
    @IBOutlet weak var paketLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var pricePackageLbl: UILabel!
    
    func setCell(data: PetShopListModel?) {
        guard let data = data else { return }
        if let photo = data.petshop_photo, !photo.isEmpty {
            let url = URL(string: photo)
            self.petshopImgView.kf.setImage(with: url)
        } else {
            self.petshopImgView.image = #imageLiteral(resourceName: "defaultEmptyPhoto")
        }
        petshopImgView.layer.cornerRadius = 10
        paketLbl.text = "\(data.petshop_name ?? "") - \(data.duration ?? 0) hari"
        addressLbl.text = data.petshop_address ?? "alamat kosong"
        pricePackageLbl.text = "\(data.price ?? 0)".currencyInputFormatting()
    }
    
}
