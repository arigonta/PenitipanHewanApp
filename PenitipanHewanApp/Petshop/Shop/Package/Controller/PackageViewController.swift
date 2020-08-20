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
    var packageList = [PetShopListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: To Style
        addPackage.setButtonMainStyle()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
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
    private func sendRequest(completion: (([PetShopListModel]?, Error?) -> Void)? = nil) {
        let currentId = UserDefaultsUtils.shared.getCurrentId()
        let url = "\(CommonHelper.shared.BASE_URL)petshop/package/list?animal_id&petshop_id=\(currentId)"
        
        NetworkHelper.shared.connect(url: url, params: nil, model: PetShopListAPIModel.self) { (result) in
            switch result {
            case .failure(let err):
                completion?(nil, err)
                break
            case .success(let value):
                completion?(value.data, nil)
            }
        }
    }
    
    private func handleSuccessGetData(_ data: [PetShopListModel]?) {
        guard let dataList = data else {
            self.showToast(message: "gagal mendapatkan data")
            return
        }
        self.packageList = dataList
        tableView.reloadData()
    }
}
