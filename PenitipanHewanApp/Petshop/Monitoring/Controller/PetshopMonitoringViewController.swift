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
    
    // MARK: Var
    lazy var refreshController: UIRefreshControl = .init()
    var monitoringList = [MonitoringModel]()
    var role = UserDefaultsUtils.shared.getRole()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        // register xib to table view
        let emptyCellNib = UINib(nibName: "generalEmptyCell", bundle: nil)
        tableView.register(emptyCellNib, forCellReuseIdentifier: "generalEmptyCell")
        
        // for add refresh on table view
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        
        getData()
    }
    
    @objc func refreshView() {
        getData {
            self.refreshController.endRefreshing()
        }
    }
}

// MARK: - API
extension PetshopMonitoringViewController {
    private func getData(completion: (() -> Void)? = nil) {
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
        completion?()
    }
    private func sendRequest(completion: (([MonitoringModel]?, Error?) -> Void)? = nil) {
        let currentId = UserDefaultsUtils.shared.getCurrentId()
        var url = ""
        if role.elementsEqual("petshop") {
            url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation/list?petshop_id=\(currentId)&status=10"
        } else {
            url = "\(CommonHelper.shared.BASE_URL)petshop/package/user/reservation/list?user_id=\(currentId)"
        }
        
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
