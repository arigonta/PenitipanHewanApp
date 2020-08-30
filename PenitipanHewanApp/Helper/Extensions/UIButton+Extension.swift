//
//  UIButton+Extension.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setButtonMainStyle() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = ColorHelper.instance.mainGreen
        self.setTitleColor(.white, for: .normal)
    }
    func setSecondaryButtonStyle() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorHelper.instance.mainGreen.cgColor
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.setTitleColor(ColorHelper.instance.mainGreen, for: .normal)
    }
    
    func setCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func setCornerWithBorder(radius: CGFloat, borderColor: UIColor, titleColor: UIColor, backgroundColor: UIColor) {
        self.layer.cornerRadius = radius
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1
    }
}
