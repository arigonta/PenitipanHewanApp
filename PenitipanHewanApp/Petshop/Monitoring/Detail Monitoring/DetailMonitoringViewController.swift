//
//  DetailMonitoringViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 24/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

enum MonitoringSectionType: Int {
    case HeadMonitoring
    case DetailMonitoring
    
    init(index: Int) {
        switch index {
        case 0:
            self = .HeadMonitoring
        default :
            self = .DetailMonitoring
        }
    }
}

class DetailMonitoringViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var isHidden = true
    var selectedRow = 0
    var tempDates = ["2020-08-24","2020-08-25", "2020-08-26", "2020-08-27", "2020-08-28", "2020-08-29"]
    var tempDate = ""
    var tempreservationPackageID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Paket Penitipan Buwung Uyuh 7 Hari"
        getCurrentDate()
        tableView.tableFooterView = UIView()
    }
    
    private func getCurrentDate() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        tempDate = formattedDate
    }
    
}
