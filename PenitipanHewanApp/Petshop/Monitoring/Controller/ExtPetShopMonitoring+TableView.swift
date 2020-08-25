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
        let dataCount = monitoringList.count
        return dataCount == 0 ? 1 : dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCount = monitoringList.count
        
        if dataCount == 0 {
            // data nil and will set cell with emptyCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalEmptyCell") as? generalEmptyCell else { return UITableViewCell() }
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            return cell
            
        } else {
            // data not nil and will set cell for monitoring list cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetShopMonitoringTableViewCell", for: indexPath) as? PetShopMonitoringTableViewCell else { return UITableViewCell.init() }
            tableView.separatorStyle = .singleLine
            tableView.allowsSelection = true
            cell.labelAge.text = monitoringList[indexPath.row].age
            cell.labelName.text = monitoringList[indexPath.row].animalName
            cell.labelRas.text = monitoringList[indexPath.row].animalRacial
            cell.labelColor.text = monitoringList[indexPath.row].color
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataCount = monitoringList.count
        return dataCount != 0 ? 120 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "DetailMonitoring", bundle: nil)
        if let detailMonitoring = storyBoard.instantiateViewController(withIdentifier: "DetailMonitoring") as? DetailMonitoringViewController {
            detailMonitoring.tempMonitoringModel = monitoringList[indexPath.row]
            detailMonitoring.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailMonitoring, animated: true)
        }
    }
}
