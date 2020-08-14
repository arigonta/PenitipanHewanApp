//
//  PackageViewController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class PackageViewController: UIViewController {

    @IBOutlet weak var addPackage: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: To Style
        addPackage.setButtonMainStyle()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addPackage(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "DetailPackage", bundle: nil)
        if let detailPackage = storyBoard.instantiateViewController(withIdentifier: "DetailPackageViewController") as? DetailPackageViewController {
            detailPackage.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailPackage, animated: true)
        }
    }
    
}
