//
//  UserProfileViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import CoreData

protocol UserProfileViewProtocol: class {
    func reloadData()
    func updateImage(image: UIImage)
}

class UserProfileViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - var
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var presenter: UserProfilePresenterProtocol?
    var imgProfile: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        window = appDelegate.window
        
        presenter = UserProfilePresenter(self)
        
        setTable()
    }

    @IBAction func logoutAction(_ sender: Any) {
//        deleteAllData()
        UserDefaults.standard.removeObject(forKey: CommonHelper.shared.isLogin)
        UserDefaults.standard.removeObject(forKey: CommonHelper.shared.lastRole)
        guard let window = window else { return }
        self.goToLogin(window: window)
    }
    
    private func deleteAllData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
    }
}

// MARK: - view
extension UserProfileViewController {
    func setTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let headerNib = UINib(nibName: "UserProfileHeaderCell", bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: "UserProfileHeaderCell")
        
        let dataNib = UINib(nibName: "UserProfileEditDataCell", bundle: nil)
        tableView.register(dataNib, forCellReuseIdentifier: "UserProfileEditDataCell")
        
        let saldoNib = UINib(nibName: "UserProfileSaldoCell", bundle: nil)
        tableView.register(saldoNib, forCellReuseIdentifier: "UserProfileSaldoCell")
        
        let passNib = UINib(nibName: "UserProfilePasswordCell", bundle: nil)
        tableView.register(passNib, forCellReuseIdentifier: "UserProfilePasswordCell")
    }
}

// MARK: - Table delegate
extension UserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 1:
            presenter?.directToTopUp(self)
        case 2:
            presenter?.directToEditData(self)
        case 3:
            presenter?.directToChangePassword(self)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2 {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.8833118081, green: 0.8779963851, blue: 0.8911830187, alpha: 1)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            return 5
        }
        return 0
    }
    
}

// MARK: - Table datasource
extension UserProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        switch indexPath.section {
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileHeaderCell", for: indexPath) as? UserProfileHeaderCell
            else { return UITableViewCell() }
            cell.setCell()
            if imgProfile != nil {
                cell.imageProfile.image = imgProfile
            }
            cell.onclickImage = { [weak self] in
                guard let self = self else { return }
                self.presenter?.openAlert(self)
            }
            
            return cell
            
        case 1:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileSaldoCell", for: indexPath) as? UserProfileSaldoCell
            else { return UITableViewCell() }
            
            return cell
            
        case 2:
            tableView.separatorStyle = .singleLine
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileEditDataCell", for: indexPath) as? UserProfileEditDataCell
            else { return UITableViewCell() }
            
            return cell
            
        case 3:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfilePasswordCell", for: indexPath) as? UserProfilePasswordCell
            else { return UITableViewCell() }
            
            return cell
            
        default:
            tableView.separatorStyle = .none
            return UITableViewCell()
        }
    }
    
}

extension UserProfileViewController: UserProfileViewProtocol {
    func reloadData() {
        
    }
    
    func updateImage(image: UIImage) {
        self.imgProfile = image
        tableView.reloadData()
    }
    
    
}
