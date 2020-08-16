//
//  ExtPetShopMonitoring+TableView.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 16/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

extension PetshopMonitoringViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let PetShopMonitoringTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PetShopMonitoringTableViewCell", for: indexPath) as? PetShopMonitoringTableViewCell {
            return PetShopMonitoringTableViewCell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
