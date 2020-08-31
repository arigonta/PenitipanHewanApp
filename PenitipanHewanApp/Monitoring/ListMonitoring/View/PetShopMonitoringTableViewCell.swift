//
//  PetShopMonitoringTableViewCell.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 16/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class PetShopMonitoringTableViewCell: UITableViewCell {
    @IBOutlet weak var labelColor: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelRas: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var viewDuration: UIView!
    
    override func awakeFromNib() {
        viewDuration.layer.cornerRadius = 10
        viewDuration.layer.masksToBounds = true
        viewDuration.layer.borderWidth = 1
        viewDuration.layer.borderColor = #colorLiteral(red: 0.7960784314, green: 0.631372549, blue: 0.0862745098, alpha: 1)
        viewDuration.backgroundColor = ColorHelper.yellow
        labelDuration.textColor = .white
    }
}
