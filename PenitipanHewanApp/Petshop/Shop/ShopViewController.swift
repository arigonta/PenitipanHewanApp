//
//  ShopViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reservationView: UIView!
    @IBOutlet weak var paketView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationView.isHidden = false
        paketView.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func segmentedTapped(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            reservationView.isHidden = false
            paketView.isHidden = true
        case 1:
            reservationView.isHidden = true
            paketView.isHidden = false
        default:
            break
        }
    }
    
}
