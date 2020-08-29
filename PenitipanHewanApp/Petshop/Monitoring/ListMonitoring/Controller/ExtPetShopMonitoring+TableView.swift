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
            let data = monitoringList[indexPath.row]
            cell.labelAge.text = "\(data.age ?? "0") Tahun"
            cell.labelName.text = data.animalName
            cell.labelRas.text = data.animalRacial
            cell.labelColor.text = data.color
            cell.labelStatus.text = setStatus(data.status ?? -2)
            cell.labelStatus.textColor = setColorStatus(data.status ?? -2)
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
        if status != 2 && status != 0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "DetailMonitoring", bundle: nil)
            if let detailMonitoring = storyBoard.instantiateViewController(withIdentifier: "DetailMonitoring") as? DetailMonitoringViewController {
                detailMonitoring.tempMonitoringModel = monitoringList[indexPath.row]
                detailMonitoring.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detailMonitoring, animated: true)
            }
        }
        
    }
}

extension PetshopMonitoringViewController {
    private func setStatus(_ status: Int) -> String {
        switch status {
        case 2:
            return "Menunggu Persetujuan"
        case 10:
            return "Aktif"
        case 0:
            return "Di Tolak"
        case -1:
            return "selesai"
        default:
            return ""
        }
    }
    
    private func setColorStatus(_ status: Int) -> UIColor {
        switch status {
        case 2:
            return ColorHelper.yellow
        case 10:
            return ColorHelper.instance.mainGreen
        case 0:
            return ColorHelper.red
        case -1:
            return ColorHelper.instance.mainGreen
        default:
            return .black
        }
    }
}
