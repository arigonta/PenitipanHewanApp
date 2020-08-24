//
//  ReservationTableViewCell.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

protocol ReservationVCtoCellProtocol {
    func accept(_ indexPath: IndexPath)
    func decline(_ indexPath: IndexPath)
}

import UIKit

class ReservationTableViewCell: UITableViewCell {
    
    var delegate: ReservationVCtoCellProtocol?
    
    @IBOutlet weak var imagePet: UIImageView!
    @IBOutlet weak var namePet: UILabel!
    @IBOutlet weak var labelLastTimeGotSick: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelVaccine: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonDecline: UIButton!
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePet.roundedImage()
    }
    
    @IBAction func buttonAccept(_ sender: Any) {
        guard let index = indexPath else { return }
        delegate?.accept(index)
    }
    
    @IBAction func buttonDecline(_ sender: Any) {
        guard let index = indexPath else { return }
        delegate?.decline(index)
    }
}
