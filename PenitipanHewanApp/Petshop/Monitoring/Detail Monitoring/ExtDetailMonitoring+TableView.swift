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
            return tempDates.count
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
            return headMonitoringCell
        case .DetailMonitoring:
            let detailMonitoringCell = tableView.dequeueReusableCell(withIdentifier: "DetailMonitoringCell", for: indexPath) as! DetailMonitoringCell
            
            //MARK: Hide Row
            if indexPath.row == selectedRow {
                detailMonitoringCell.viewSwitchButton.forEach { (view) in
                    view.isHidden = isHidden
                }
                detailMonitoringCell.editButton.isHidden = isHidden
                detailMonitoringCell.submitButton.isHidden = isHidden
                detailMonitoringCell.noteTextField.isHidden = isHidden
            } else {
                detailMonitoringCell.viewSwitchButton.forEach { (view) in
                    view.isHidden = true
                }
                detailMonitoringCell.editButton.isHidden = true
                detailMonitoringCell.submitButton.isHidden = true
                detailMonitoringCell.noteTextField.isHidden = true
            }
            
            //MARK: Check Current Date
            if tempDates[indexPath.row] == tempDate {
                detailMonitoringCell.dateLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
//                detailMonitoringCell.dateLabel.layer.backgroundColor =
            } else {
                detailMonitoringCell.dateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            detailMonitoringCell.dateLabel.text = tempDates[indexPath.row]
            
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
                    return 340
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
            }
            tableView.reloadData()
        case .HeadMonitoring:
            break
        }
    }
}
