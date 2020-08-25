//
//  PetshopMonitoringViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class PetshopMonitoringViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var monitoringList = [MonitoringModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        getData()
    }
}

// MARK: - API
extension PetshopMonitoringViewController {
    private func getData() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest() { [weak self] (dataList, error) in
                guard let self = self else { return }
                
                self.removeSpinner(spinner)
                if error != nil {
                    self.showToast(message: "gagal mendapatkan data")
                } else {
                    self.handleSuccessGetData(dataList)
                }
            }
        }
    }
    private func sendRequest(completion: (([MonitoringModel]?, Error?) -> Void)? = nil) {
        let currentId = UserDefaultsUtils.shared.getCurrentId()
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation/list?petshop_id=\(currentId)&status=10"
        
        NetworkHelper.shared.connect(url: url, params: nil, model: MonitoringAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    private func handleSuccessGetData(_ data: [MonitoringModel]?) {
        guard let dataList = data else {
            self.showToast(message: "gagal mendapatkan data")
            return
        }
        self.monitoringList = dataList
        tableView.reloadData()
    }
}
