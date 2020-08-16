//
//  File.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 16/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func roundedImage() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
