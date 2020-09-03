//
//  Package+TableView.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

extension PackageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = packageList.count
        return dataCount == 0 ? 1 : dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCount = packageList.count
        
        if dataCount == 0 {
            tableView.separatorStyle = .none
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalEmptyCell") as? generalEmptyCell else { return UITableViewCell() }
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            return cell
            
        } else {
            if let packageCell = tableView.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for: indexPath) as? PackageTableViewCell {
                packageCell.titlePackageLabel.text = packageList[indexPath.row].package_name
                packageCell.deadlineLabel.text = "Deadline Paket: \(packageList[indexPath.row].duration ?? 0) Hari"
                packageCell.packagePriceLabel.text = "Harga Paket: Rp.\(packageList[indexPath.row].price ?? 0)"
                packageCell.typeAnimalLabel.text = "Tipe Hewan: \(packageList[indexPath.row].animal_name ?? "")"
                packageCell.descLabel.text = packageList[indexPath.row].deskripsi
                return packageCell
            } else {
                return UITableViewCell.init()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
