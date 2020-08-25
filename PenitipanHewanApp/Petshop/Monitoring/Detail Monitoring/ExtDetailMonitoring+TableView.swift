//
//  ExtDetailMonitoring+TableView.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 25/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

extension DetailMonitoringViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monitoringSectionType = MonitoringSectionType.init(index: section)
        switch monitoringSectionType {
        case .HeadMonitoring:
            return 1
        case .DetailMonitoring:
            return historyModel.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let monitoringSectionType = MonitoringSectionType.init(index: indexPath.section)
        switch monitoringSectionType {
        case .HeadMonitoring:
            let headMonitoringCell = tableView.dequeueReusableCell(withIdentifier: "HeaderDetailMonitoringCell", for: indexPath) as! HeaderDetailMonitoringCell
            headMonitoringCell.nameLabel.text = tempMonitoringModel?.animalName
            headMonitoringCell.rasLabel.text = tempMonitoringModel?.animalRacial
            headMonitoringCell.ageLabel.text = tempMonitoringModel?.age
            headMonitoringCell.colorLabel.text = tempMonitoringModel?.color
            headMonitoringCell.lastSickLabel.text = tempMonitoringModel?.lastTimeGotSick
            headMonitoringCell.noteLabel.text = tempMonitoringModel?.note
            return headMonitoringCell
        case .DetailMonitoring:
            let detailMonitoringCell = tableView.dequeueReusableCell(withIdentifier: "DetailMonitoringCell", for: indexPath) as! DetailMonitoringCell
            
            let isRole = UserDefaultsUtils.shared.getRole()
        
            //MARK: Did Select Hide Row
            if indexPath.row == selectedRow {
                detailMonitoringCell.viewSwitchButton.forEach { (view) in
                    view.isHidden = isHidden
                }
                detailMonitoringCell.editButton.isHidden = isHidden
                detailMonitoringCell.noteTextField.isHidden = isHidden
                
                //MARK: Edit
                if isEditing {
                    detailMonitoringCell.submitButton.isHidden = false
                    detailMonitoringCell.switchsButton.forEach { (switchButton) in
                        switchButton.isEnabled = true
                    }
                } else {
                    detailMonitoringCell.submitButton.isHidden = true
                    detailMonitoringCell.switchsButton.forEach { (switchButton) in
                        switchButton.isEnabled = false
                    }
                }
                
            } else {
                detailMonitoringCell.viewSwitchButton.forEach { (view) in
                    view.isHidden = true
                }
                detailMonitoringCell.editButton.isHidden = true
                detailMonitoringCell.submitButton.isHidden = true
                detailMonitoringCell.noteTextField.isHidden = true
            }
            
            //MARK: Check Current Date
            if currentDate == historyModel[indexPath.row].date {
                detailMonitoringCell.dateLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            } else {
                detailMonitoringCell.dateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            detailMonitoringCell.dateLabel.text = historyModel[indexPath.row].date
            detailMonitoringCell.breakfastButton.isOn = CommonHelper.shared.convertIntToBool(input: historyModel[indexPath.row].isHasBreakfast ?? 0)
            detailMonitoringCell.lunchButton.isOn = CommonHelper.shared.convertIntToBool(input: historyModel[indexPath.row].isHasLunch ?? 0)
            detailMonitoringCell.dinnerButton.isOn = CommonHelper.shared.convertIntToBool(input: historyModel[indexPath.row].isHasDinner ?? 0)
            detailMonitoringCell.vitaminButton.isOn = CommonHelper.shared.convertIntToBool(input: historyModel[indexPath.row].isHasVitamin ?? 0)
            detailMonitoringCell.showerButton.isOn = CommonHelper.shared.convertIntToBool(input: historyModel[indexPath.row].isHasShower ?? 0)
            detailMonitoringCell.vaccineButton.isOn = CommonHelper.shared.convertIntToBool(input: historyModel[indexPath.row].isHasVaccine ?? 0)
            
            detailMonitoringCell.noteTextField.text = historyModel[indexPath.row].note
            detailMonitoringCell.tempReservationPackageHistory = reservationPackageID
            detailMonitoringCell.delegate = self
            
            if isRole == "customer" {
                detailMonitoringCell.editButton.isHidden = true
                detailMonitoringCell.noteTextField.isUserInteractionEnabled = false
            }
            
            return detailMonitoringCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let monitoringSectionType = MonitoringSectionType.init(index: indexPath.section)
        switch monitoringSectionType {
        case .HeadMonitoring:
            return 400
        case .DetailMonitoring:
            if indexPath.row == selectedRow {
                if isHidden {
                    return 40
                } else {
                    if isEditing {
                        return 400
                    } else {
                        return 300
                    }
                }
            } else {
                return 40
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monitoringSectionType = MonitoringSectionType.init(index: indexPath.section)
        switch monitoringSectionType {
        case .DetailMonitoring:
            selectedRow = indexPath.row
            if isHidden {
                isHidden = false
            } else {
                isHidden = true
                isEditing = false
            }
            reservationPackageID = historyModel[indexPath.row].reservationPackageHistoryID
            tableView.reloadData()
        case .HeadMonitoring:
            break
        }
    }
}

extension DetailMonitoringViewController: detailMonitoringCellProtocol {
    func submitButton(history: History?) {
        if let hist = history {
            postData(dataPost: hist)
        }
    }
    
    func editButton() {
        if isEditing == false {
            isEditing = true
            tableView.reloadData()
        }
    }
}
