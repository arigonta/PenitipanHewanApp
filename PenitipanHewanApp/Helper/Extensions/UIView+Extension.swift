//
//  UIView+Extension.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 09/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    enum DropShadowDirection {
        case top
        case bottom
        case center
    }
    
    func addDropShadow(to direction: DropShadowDirection) {
        layer.shadowColor = ColorHelper.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.masksToBounds = false
        switch direction {
        case .top:
            layer.shadowOffset = .init(width: 0, height: -2)
        case .bottom:
            layer.shadowOffset = .init(width: 0, height: 2)
        default:
            layer.shadowOffset = .zero
        }
    }
}
