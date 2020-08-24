//
//  DetailMonitoringCell.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 25/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

protocol detailMonitoringCellProtocol {
    func editButton()
    func breakfastButton()
    func lunchButton()
    func dinnerButton()
    func vitaminButton()
    func showerButton()
    func submitButton()
}

import UIKit

class DetailMonitoringCell: UITableViewCell {

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
    
    @IBOutlet var viewSwitchButton: [UIView]!
    
    var delegate: detailMonitoringCellProtocol?
    
    override func awakeFromNib() {
        submitButton.setButtonMainStyle()
        self.selectionStyle = .none
    }
    
    @IBAction func editButton(_ sender: Any) {
        delegate?.editButton()
    }
    
    @IBAction func breakfastButton(_ sender: Any) {
        delegate?.breakfastButton()
    }
    
    @IBAction func lunchButton(_ sender: Any) {
        delegate?.lunchButton()
    }
    
    @IBAction func dinnerButton(_ sender: Any) {
        delegate?.dinnerButton()
    }
    
    @IBAction func vitaminButton(_ sender: Any) {
        delegate?.vitaminButton()
    }
    
    @IBAction func showerButton(_ sender: Any) {
        delegate?.showerButton()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        delegate?.submitButton()
    }
}
