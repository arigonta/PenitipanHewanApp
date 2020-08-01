//
//  PetshopHeaderProfileCell.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class PetshopHeaderProfileCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    public var onclickImage: (() -> Void)?
    
    func setSell() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        imgProfile.isUserInteractionEnabled = true
        
        imgProfile.addGestureRecognizer(tap)
    }
    
    @objc private func imgTapped() {
        self.onclickImage?()
    }
}
