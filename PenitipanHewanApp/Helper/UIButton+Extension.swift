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
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.clipsToBounds = true
        self.backgroundColor = ColorHelper.instance.mainGreen
        self.setTitleColor(.white, for: .normal)
    }
}
