//
//  UserProfileHeaderCell.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserProfileHeaderCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    
    public var onclickImage: (() -> Void)?
    
    func setCell() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        imageProfile.isUserInteractionEnabled = true
        
        imageProfile.addGestureRecognizer(tap)
    }
    
    @objc private func imgTapped() {
        self.onclickImage?()
    }
}
