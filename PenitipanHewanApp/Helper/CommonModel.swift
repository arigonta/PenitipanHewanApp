//
//  CommonModel.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

// MARK: MODEL ALERT
open class AlertModel {
    var title: String?
    var subtitle: String?
    var style: UIAlertController.Style = .alert
    var actions: [AlertActionModel]?
    
    init(_ title: String, _ subtitle: String, _ style: UIAlertController.Style, _ actions: [AlertActionModel]) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.actions = actions
    }
}

open class AlertActionModel {
    var title: String?
    var style: UIAlertAction.Style = .default
    var onclick: ((UIAlertAction) -> Void)?
    init(_ title: String, _ style: UIAlertAction.Style, _ handler: ((UIAlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.onclick = handler
    }
}

class MainResponse: Codable {
    var code: Int?
    var status: String?
}
