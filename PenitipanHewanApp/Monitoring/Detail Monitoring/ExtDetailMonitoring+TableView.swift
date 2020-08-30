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
            headMonitoringCell.ageLabel.text = "\(tempMonitoringModel?.age ?? 0) Tahun"
            headMonitoringCell.colorLabel.text = tempMonitoringModel?.color
            headMonitoringCell.lastSickLabel.text = tempMonitoringModel?.lastTimeGotSick
            headMonitoringCell.noteLabel.text = tempMonitoringModel?.note ?? "-"
            
            headMonitoringCell.ownerView.isHidden = role.contains("customer") ? true : false
            headMonitoringCell.ownerNameLbl.text = dataOwner?.name ?? "-"
            headMonitoringCell.ownerPhoneLbl.text = dataOwner?.phone ?? "-"
            headMonitoringCell.ownerAddressLbl.text = dataOwner?.address ?? "-"
            
            if let photo = tempMonitoringModel?.animalPhoto, !photo.isEmpty {
                let url = URL(string: photo)
                headMonitoringCell.animalImage.kf.setImage(with: url)
                headMonitoringCell.animalImage.roundedImage()
            }
            
            return headMonitoringCell
            
        case .DetailMonitoring:
            let detailMonitoringCell = tableView.dequeueReusableCell(withIdentifier: "DetailMonitoringCell", for: indexPath) as! DetailMonitoringCell
            
            let isRole = UserDefaultsUtils.shared.getRole()
            let data = historyModel[indexPath.row]
            let commonHelper = CommonHelper.shared
            
            detailMonitoringCell.consTopSeparatorBottom.constant =  0
        
            //MARK: Did Select Hide Row
            if indexPath.row == selectedRow {
                detailMonitoringCell.viewSwitchButton.forEach { (view) in
                    view.isHidden = isHidden
                }
                detailMonitoringCell.editButton.isHidden = isHidden
                detailMonitoringCell.containerTextField.isHidden = isHidden
                detailMonitoringCell.consTopSeparatorBottom.constant = isHidden ? 0 : 8
                
                //MARK: Edit
                if isEditing {
                    detailMonitoringCell.containerBtn.isHidden = false
                    detailMonitoringCell.switchsButton.forEach { (switchButton) in
                        switchButton.isEnabled = true
                    }
                } else {
                    detailMonitoringCell.containerBtn.isHidden = true
                    detailMonitoringCell.switchsButton.forEach { (switchButton) in
                        switchButton.isEnabled = false
                    }
                }
                
            } else {
                detailMonitoringCell.viewSwitchButton.forEach { (view) in
                    view.isHidden = true
                }
                detailMonitoringCell.editButton.isHidden = true
                detailMonitoringCell.containerBtn.isHidden = true
                detailMonitoringCell.containerTextField.isHidden = true
            }
            
            let newDate = commonHelper.getNewDateFormat(date: data.date ?? "", fromFormat: commonHelper.dateFormatYear, toFormat: commonHelper.dateFormatStringComplete)
            detailMonitoringCell.dateLabel.text = newDate
            detailMonitoringCell.headerView.backgroundColor = .white
            detailMonitoringCell.dateLabel.textColor = ColorHelper.instance.mainGreen
            
            //MARK: Check Current Date
            if currentDate == historyModel[indexPath.row].date {
                detailMonitoringCell.dateLabel.textColor = .white
                detailMonitoringCell.headerView.backgroundColor = ColorHelper.instance.mainGreen
                detailMonitoringCell.dateLabel.text = "Hari ini"
            }
            
            detailMonitoringCell.breakfastButton.isOn = commonHelper.convertIntToBool(input: data.isHasBreakfast ?? 0)
            detailMonitoringCell.lunchButton.isOn = commonHelper.convertIntToBool(input: data.isHasLunch ?? 0)
            detailMonitoringCell.dinnerButton.isOn = commonHelper.convertIntToBool(input: data.isHasDinner ?? 0)
            detailMonitoringCell.vitaminButton.isOn = commonHelper.convertIntToBool(input: data.isHasVitamin ?? 0)
            detailMonitoringCell.showerButton.isOn = commonHelper.convertIntToBool(input: data.isHasShower ?? 0)
            detailMonitoringCell.vaccineButton.isOn = commonHelper.convertIntToBool(input: data.isHasVaccine ?? 0)
            
            detailMonitoringCell.noteTextField.text = data.note
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monitoringSectionType = MonitoringSectionType.init(index: indexPath.section)
        switch monitoringSectionType {
        case .DetailMonitoring:
            currentRow = indexPath.row
            selectedRow = indexPath.row
            if isHidden {
                isHidden = false
            } else {
                isHidden = true
                isEditing = false
            }
            reservationPackageID = historyModel[indexPath.row].reservationPackageHistoryID
            self.indexPathFoccus = indexPath
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    tableView.reloadData()
                    self.scrollToRow()
                }, completion: nil)
            }
        case .HeadMonitoring:
            break
        }
    }
    
    private func scrollToRow() {
        let topRow = IndexPath(row: currentRow,
                               section: 1)
                               
        self.tableView.scrollToRow(at: topRow,
                                   at: .middle,
                                   animated: true)
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return indexPathFoccus
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
            self.scrollToRow()
            tableView.reloadData()
        }
    }
}
