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
    @IBOutlet weak var activeBtn: UIButton!
    @IBOutlet weak var TolakBtn: UIButton!
    @IBOutlet weak var SelesaiBtn: UIButton!
    @IBOutlet weak var menungguBtn: UIButton!
    
    // MARK: Var
    lazy var refreshController: UIRefreshControl = .init()
    var monitoringList = [MonitoringModel]()
    var role = UserDefaultsUtils.shared.getRole()
    var spinner: UIView?
    
    // status 0 = tolak
    // status 2 = waiting approval
    // status 10 = aktif
    var status: Int = 10
    
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
        setBtnSorting()
        getData()
    }
    
    @objc func refreshView() {
        getData {
            self.refreshController.endRefreshing()
        }
    }
}

// MARK: - loading
extension PetshopMonitoringViewController {
    
    /// Show loading
    private func showLoading() {
        self.showSpinner { [weak self] (spinner) in
            guard let self = self else { return }
            self.spinner = spinner
        }
    }
    
    
    /// remove loading
    private func removeLoading() {
        guard let spinner = self.spinner else { return }
        self.removeSpinner(spinner)
    }
}

// MARK: - API
extension PetshopMonitoringViewController {
    
    /// Method for get Data list reservation Pet
    /// - Parameter completion: closure for adding void
    private func getData(completion: (() -> Void)? = nil) {
        let currentId = UserDefaultsUtils.shared.getCurrentId()
        var url = ""
        if role.elementsEqual("petshop") {
            url = "\(CommonHelper.shared.BASE_URL)petshop/package/reservation/list?petshop_id=\(currentId)&status=\(status)"
        } else {
            url = "\(CommonHelper.shared.BASE_URL)petshop/package/user/reservation/list?user_id=\(currentId)"
        }
        
        showLoading()
        NetworkHelper.shared.connect(url: url, params: nil, model: MonitoringAPIModel.self) { [weak self] (result) in
            guard let self = self else { return }
            self.removeLoading()
            
            switch result {
            case .failure(let err):
                self.errorResponse(error: err)
                
            case .success(let value):
                let dataList = value.data
                let filter = dataList.filter { $0.status == self.status }
                self.monitoringList = filter
                self.tableView.reloadData()
            }
        }
        
        completion?()
    }
    
    // MARK: error handling
    /// Method for handling error response from network threading
    /// - Parameter error: Model Error From network threading
    private func errorResponse(error: Error) {
        if let newError = error as? ErrorResponse {
            self.showToast(message: newError.messages)
        }
    }
}

// MARK: - sorting
extension PetshopMonitoringViewController {
    func setBtnSorting() {
        activeBtn.setButtonMainStyle()
        menungguBtn.setSecondaryButtonStyle()
        TolakBtn.setSecondaryButtonStyle()
        SelesaiBtn.setSecondaryButtonStyle()
        
        menungguBtn.isHidden = role.contains("petshop") ? true : false
        
        activeBtn.addTarget(self, action: #selector(activeBtnTapped), for: .touchUpInside)
        menungguBtn.addTarget(self, action: #selector(menungguBtnTapped), for: .touchUpInside)
        TolakBtn.addTarget(self, action: #selector(tolakBtnTapped), for: .touchUpInside)
        SelesaiBtn.addTarget(self, action: #selector(selesaiBtnTapped), for: .touchUpInside)
    }
    
    @objc func activeBtnTapped() {
        let active = 10
        activeBtn.setButtonMainStyle()
        menungguBtn.setSecondaryButtonStyle()
        TolakBtn.setSecondaryButtonStyle()
        SelesaiBtn.setSecondaryButtonStyle()
        if status != active {
            status = active
            getData()
        }
    }
    
    @objc func menungguBtnTapped() {
        let menunggu = 2
        activeBtn.setSecondaryButtonStyle()
        menungguBtn.setButtonMainStyle()
        TolakBtn.setSecondaryButtonStyle()
        SelesaiBtn.setSecondaryButtonStyle()
        if status != menunggu {
            status = menunggu
          getData()
        }
        
    }
    
    @objc func tolakBtnTapped() {
        let tolak = 0
        activeBtn.setSecondaryButtonStyle()
        menungguBtn.setSecondaryButtonStyle()
        TolakBtn.setButtonMainStyle()
        SelesaiBtn.setSecondaryButtonStyle()
        if status != tolak {
            status = tolak
          getData()
        }
        
    }
    
    @objc func selesaiBtnTapped() {
        let selesai = 11
        activeBtn.setSecondaryButtonStyle()
        menungguBtn.setSecondaryButtonStyle()
        TolakBtn.setSecondaryButtonStyle()
        SelesaiBtn.setButtonMainStyle()
        if status != selesai {
            status = selesai
            getData()
        }
    }
}
