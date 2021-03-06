//
//  UserProfileHeaderCell.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileHeaderCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPhoneLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userAddressLbl: UILabel!
    
    public var onclickImage: (() -> Void)?
    
    var currentRole = UserDefaultsUtils.shared.getRole()
    
    func setCell(user: UserModel?) {
        setImage(user: user)
        
        userNameLbl.text = user?.name ?? "User Fullname"
        userPhoneLbl.text = user?.phone ?? "+628xxxxxxx"
        userEmailLbl.text = user?.email ?? "-"
        userAddressLbl.text = user?.address ?? "-"
    }
    
    private func setImage(user: UserModel?) {
       let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        imageProfile.image = UIImage(named: "tempProfilePict")
        imageProfile.isUserInteractionEnabled = true
        imageProfile.addGestureRecognizer(tap)
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
        
        if let photo = user?.photo, !photo.isEmpty {
            let url = URL(string: photo)
            imageProfile.kf.setImage(with: url)
        }
        
    }
    
    @objc private func imgTapped() {
        self.onclickImage?()
    }
}
