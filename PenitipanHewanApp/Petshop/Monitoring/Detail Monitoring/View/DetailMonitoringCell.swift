//
//  DetailMonitoringCell.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 25/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

protocol detailMonitoringCellProtocol {
    func editButton()
    func submitButton(history: History?)
}

import UIKit

class DetailMonitoringCell: UITableViewCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    @IBOutlet weak var lunchButton: UISwitch!
    @IBOutlet weak var dinnerButton: UISwitch!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var vitaminLabel: UILabel!
    @IBOutlet weak var vitaminButton: UISwitch!
    @IBOutlet weak var showerButton: UISwitch!
    @IBOutlet weak var showerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var breakfastButton: UISwitch!
    @IBOutlet weak var vaccineButton: UISwitch!
    @IBOutlet weak var containerTextField: UIView!
    @IBOutlet weak var containerBtn: UIView!
    @IBOutlet weak var consTopSeparatorBottom: NSLayoutConstraint!
    
    @IBOutlet var switchsButton: [UISwitch]!
    @IBOutlet var viewSwitchButton: [UIView]!
    
    var delegate: detailMonitoringCellProtocol?
    var tempHistory: History?
    var tempReservationPackageHistory: Int?
    var headerClicked: (() -> Void)?
    
    override func awakeFromNib() {
        submitButton.setButtonMainStyle()
        self.selectionStyle = .none
        
    }
    
    @IBAction func editButton(_ sender: Any) {
        delegate?.editButton()
    }
    
    @IBAction func breakfastButton(_ sender: Any) {

    }
    
    @IBAction func lunchButton(_ sender: Any) {
        
    }
    
    @IBAction func dinnerButton(_ sender: Any) {
        
    }
    
    @IBAction func vitaminButton(_ sender: Any) {
        
    }
    
    @IBAction func showerButton(_ sender: Any) {
        
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let isHasBreakfast = CommonHelper.shared.convertBoolToInt(input: breakfastButton.isOn)
        let isHasLunch = CommonHelper.shared.convertBoolToInt(input: lunchButton.isOn)
        let isHasDinner = CommonHelper.shared.convertBoolToInt(input: dinnerButton.isOn)
        let isHasVitamin = CommonHelper.shared.convertBoolToInt(input: vitaminButton.isOn)
        let isHasVaccine = CommonHelper.shared.convertBoolToInt(input: vaccineButton.isOn)
        let isHasShower = CommonHelper.shared.convertBoolToInt(input: showerButton.isOn)
        
        let value = History(reservationPackageHistoryID: tempReservationPackageHistory, reservationPackageID: nil, isHasBreakfast: isHasBreakfast, isHasLunch: isHasLunch, isHasDinner: isHasDinner, isHasVitamin: isHasVitamin, isHasVaccine: isHasVaccine, isHasShower: isHasShower, note: noteTextField.text, date: nil)
        delegate?.submitButton(history: value)
    }
}
