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
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = ColorHelper.instance.mainGreen.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setMainPickerUnderLine() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = ColorHelper.instance.mainGreen.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.setIcon(UIImage(named: "arrowDown"))
        self.semanticContentAttribute = .forceRightToLeft
    }
    
    func setRedUnderLine() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setRedPickerUnderLine() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.setIcon(UIImage(named: "arrowDown"))
        self.semanticContentAttribute = .forceRightToLeft
    }
    
    func setIcon(_ image: UIImage?) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
}
