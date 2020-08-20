//
//  UITextField+Extension.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setMainUnderLine() {
        self.layer.borderColor = #colorLiteral(red: 0.3516459167, green: 0.7204310298, blue: 0.4399796724, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
    }
    
    func setRedUnderLine() {
        self.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
    }
}
