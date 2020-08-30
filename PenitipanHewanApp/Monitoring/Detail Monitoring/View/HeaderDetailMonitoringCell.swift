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
    
    override func awakeFromNib() {
        animalImage.roundedImage()
        self.selectionStyle = .none
    }
    
}
