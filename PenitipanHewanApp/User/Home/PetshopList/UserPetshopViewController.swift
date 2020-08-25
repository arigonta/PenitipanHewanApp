//
//  UserPetshopViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

protocol UserPetshopViewProtocol {
    func updateScreen(_ data: [PetShopListModel]?)
}

class UserPetshopViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Var
    lazy var refreshController: UIRefreshControl = .init()
    public var animalType: ReferenceAnimalModel?
    public var listPetshop: [PetShopListModel]?
    var presenter: UserPetshopPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.animalType?.animal_name ?? "Hewan"
        presenter = UserPetshopPresenter(self, animalType)
        setTableView()
        presenter?.getListData(self)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // register xib cell to table view
        let cellXib = UINib(nibName: "UserPetshopCell", bundle: nil)
        tableView.register(cellXib, forCellReuseIdentifier: "cell")
        
        let emptyCellXib = UINib(nibName: "generalEmptyCell", bundle: nil)
        tableView.register(emptyCellXib, forCellReuseIdentifier: "generalEmptyCell")
        
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshView), for: .valueChanged)
    }
    
    @objc func refreshView() {
        presenter?.getListData(self)
        refreshController.endRefreshing()
    }

}

// MARK: - table
extension UserPetshopViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let data = listPetshop?[indexPath.row]
        presenter?.directToDetail(self, data)
    }
    
}

extension UserPetshopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = listPetshop?.count ?? 0
        return dataCount == 0 ? 1 : dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCount = listPetshop?.count ?? 0
        
        if dataCount == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "generalEmptyCell", for: indexPath) as? generalEmptyCell else { return UITableViewCell() }
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserPetshopCell else {
                return UITableViewCell()
            }
            tableView.allowsSelection = true
            tableView.separatorStyle = .singleLine
            let data = listPetshop?[indexPath.row]
            cell.setCell(data: data)
            return cell
        }
        
    }
}

extension UserPetshopViewController: UserPetshopViewProtocol {
    func updateScreen(_ data: [PetShopListModel]?) {
        self.listPetshop = data
        tableView.reloadData()
    }
}
