//
//  HeaderDetailMonitoringCell.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 25/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class HeaderDetailMonitoringCell: UITableViewCell {

    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rasLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var lastSickLabel: UILabel!
    
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var ownerPhoneLbl: UILabel!
    @IBOutlet weak var ownerAddressLbl: UILabel!
    @IBOutlet weak var ownerOrPetshopTitle: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var bgStatusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var phoneBtnClicked: (() -> Void)?
    var role = UserDefaultsUtils.shared.getRole()
    
    override func awakeFromNib() {
        animalImage.roundedImage()
        self.selectionStyle = .none
        phoneBtn.addTarget(self, action: #selector(phoneTapped), for: .touchUpInside)
    }
    
    @objc func phoneTapped() {
        phoneBtnClicked?()
    }
    
    func setStatus(status: Int?) {
        statusLabel.text = setStatusName(status: status ?? -1)
        statusLabel.textColor = .white
        bgStatusView.layer.cornerRadius = 10
        
        switch status {
        case 0:
            bgStatusView.backgroundColor = ColorHelper.red
        case 2:
            bgStatusView.backgroundColor = ColorHelper.yellow
        case 10:
           bgStatusView.backgroundColor = ColorHelper.instance.mainGreen
        case 11:
            bgStatusView.backgroundColor = ColorHelper.black
            
        default:
            bgStatusView.backgroundColor = ColorHelper.instance.mainGreen
        }
    }
    
    private func setStatusName(status: Int) -> String {
        if status == 2 {
            return "Menunggu persetujuan"
        } else if status == 10 {
            return "Aktif"
        } else if status == 11 {
            return "Selesai"
        } else if status == 0 {
            return role.contains("petshop") ? "Tolak" : "Ditolak"
        } else {
            return ""
        }
    }
    
}
