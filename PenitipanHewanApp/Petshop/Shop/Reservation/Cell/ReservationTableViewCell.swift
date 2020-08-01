//
//  ReservationTableViewCell.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonDecline: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonAccept(_ sender: Any) {
        
    }
    
    @IBAction func buttonDecline(_ sender: Any) {
        
    }
}
