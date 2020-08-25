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
    var isEdited = false
    var selectedRow = 0
    var currentDate = ""
    var tempMonitoringModel: MonitoringModel?
    var historyModel = [History]()
    var reservationPackageID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Paket Penitipan Buwung Uyuh 7 Hari"
        getCurrentDate()
        getData()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        tempMonitoringModel = nil
    }
    
    private func getCurrentDate() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        currentDate = formattedDate
    }
    
}

// MARK: - API
extension DetailMonitoringViewController {
    
    //MARK: POST Request Monitoring
    func postData(dataPost: History) {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.sendRequest(dataPost) { [weak self] (dataSuccess, error) in
                guard let self = self else { return }
                
                self.removeSpinner(spinner)
                if let newError = error as? ErrorResponse {
                    let message = newError.messages
                    self.showToast(message: message)
                } else {
                    self.showToast(message: "Success submit data")
                    self.getData()
                }
            }
        }
    }
    
    //MARK: POST Request Monitoring
    private func sendRequest(_ dataPost: History, completion: ((History?, Error?) -> Void)? = nil) {
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation/history/action"
        NetworkHelper.shared.connect(url: url, params: dataPost.representation, model: History.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value, nil)
            }
        }
    }
    
    private func getData() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            
            self.getRequest() { [weak self] (dataList, error) in
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
    
    //MARK: Get Request Monitoring
    private func getRequest(completion: (([History]?, Error?) -> Void)? = nil) {
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation/details/history?reservation_package_id=\(tempMonitoringModel?.reservationPackageID ?? 0)"
        
        NetworkHelper.shared.connect(url: url, params: nil, model: ReservationActionAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data.history, nil)
            }
        }
    }
    
    private func handleSuccessGetData(_ data: [History]?) {
        guard let dataList = data else {
            self.showToast(message: "gagal mendapatkan data")
            return
        }
        self.historyModel = dataList
        tableView.reloadData()
    }
}
