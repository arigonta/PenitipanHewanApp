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
    
    // MARK: var
    var currentId = UserDefaultsUtils.shared.getCurrentId()
    var refreshControl: UIRefreshControl = .init()
    
    var dataReservation: [MonitoringModel]?
    var spinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataList()
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    @objc func refreshTable() {
        getDataList {
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - API
extension ReservationViewController {
    
    private func getDataList(completion: (() -> Void)? = nil) {
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation/list?petshop_id=\(currentId)&status=2"
        self.showLoading()
        sendRequest(url: url, param: nil, model: MonitoringAPIModel.self) { [weak self] (dataSuccess, err) in
            guard let self = self else { return }
            
            self.removeLoading()
            if let error = err as? ErrorResponse {
                self.showToast(message: error.messages)
            } else {
                
                guard let dataList = dataSuccess?.data else { return }
                self.dataReservation = dataList
                self.tableView.reloadData()
            }
        }
        completion?()
    }
    
    func postActionReservation(param: [String: Any]) {
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation/action"
        
        self.showLoading()
        sendRequest(url: url, param: param, model: ReservationActionAPIModel.self) { [weak self] (dataSuccess, err) in
            guard let self = self else { return }
            self.removeLoading()
            
            if let error = err as? ErrorResponse {
                self.showToast(message: error.messages)
            } else {
                
                self.getDataList()
            }
        }
        
    }
    
    private func sendRequest<T: Decodable>(url: String, param: [String: Any]?, model: T.Type,completion: ((T?, Error?) -> Void)? = nil) {
        NetworkHelper.shared.connect(url: url, params: param, model: T.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
            case .success(let value):
                completion?(value, nil)
            }
        }
    }
}

extension ReservationViewController {
    func showLoading() {
        showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            self.spinner = spinner
        }
    }
    
    func removeLoading() {
        removeSpinner(self.spinner ?? UIView())
    }
}
