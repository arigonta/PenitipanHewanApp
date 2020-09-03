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
    var spinner: UIView?
    var packageList = [PetShopListModel]()
    var refreshControl: UIRefreshControl = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: To Style
        addPackage.setButtonMainStyle()
        tableView.tableFooterView = UIView()
        
        // register xib to table view
        let emptyCellNib = UINib(nibName: "generalEmptyCell", bundle: nil)
        tableView.register(emptyCellNib, forCellReuseIdentifier: "generalEmptyCell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }
    
    @objc func refreshTable() {
        getData {
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func addPackage(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "DetailPackage", bundle: nil)
        if let detailPackage = storyBoard.instantiateViewController(withIdentifier: "DetailPackageViewController") as? DetailPackageViewController {
            detailPackage.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailPackage, animated: true)
        }
    }
}

// MARK: - API
extension PackageViewController {

    /// Method for get data Package List
    /// - Parameter completion: closure
    private func getData(completion: (() -> Void)? = nil) {
        let currentId = UserDefaultsUtils.shared.getCurrentId()
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/list?animal_id&petshop_id=\(currentId)"
        
        showLoading()
        NetworkHelper.shared.connect(url: url, params: nil, model: PetShopListAPIModel.self) { [weak self] (result) in
            guard let self = self else { return }
            self.removeLoading()
            
            switch result {
            case .failure(let err):
                self.errorResponse(error: err)
                
            case .success(let value):
                self.packageList = value.data
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

// MARK: - loading
extension PackageViewController {
    
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
