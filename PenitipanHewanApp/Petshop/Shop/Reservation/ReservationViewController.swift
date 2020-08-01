//
//  ReservationViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dummyData = ["A","B","C","D"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}
