//
//  PetshopProfileViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import CoreData

protocol PetshopProfileViewProtocol: class {
    func reloadData()
    func updateImage(image: UIImage)
}

class PetshopProfileViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    
    var presenter: PetshopProfilePresenterProtocol?
    var imageProfile: UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        window = appDelegate.window
        initializeHidKeyboard()
        presenter = PetshopProfilePresenter(self)
        setTable()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
//        deleteAllData()
        UserDefaultsUtils.shared.removeAllUserDefault()
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

// MARK: - setView
extension PetshopProfileViewController {
    private func setTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let headerNib = UINib(nibName: "PetshopHeaderProfileCell", bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: "PetshopHeaderProfileCell")
        
        let saldoNib = UINib(nibName: "PetshopSaldoProfileCell", bundle: nil)
        tableView.register(saldoNib, forCellReuseIdentifier: "PetshopSaldoProfileCell")
        
        let dataNib = UINib(nibName: "PetshopEditProfileCell", bundle: nil)
        tableView.register(dataNib, forCellReuseIdentifier: "PetshopEditProfileCell")
        
        let passwordNib = UINib(nibName: "PetshopEditPasswordProfileCell", bundle: nil)
        tableView.register(passwordNib, forCellReuseIdentifier: "PetshopEditPasswordProfileCell")
    }
}

// MARK: - tableview
extension PetshopProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 2:
            presenter?.directToEditData(self)
        case 3:
            presenter?.directToChangePassword(self)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2 {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.8833118081, green: 0.8779963851, blue: 0.8911830187, alpha: 1)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            return 8
        }
        return 0
    }
}

extension PetshopProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let section = indexPath.section
        
        switch section {
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "PetshopHeaderProfileCell", for: indexPath) as? PetshopHeaderProfileCell
            else { return UITableViewCell() }
            cell.setSell()
            if imageProfile != nil {
                cell.imageView?.image = imageProfile
            }
            cell.onclickImage = { [weak self] in
                guard let self = self else { return }
                self.presenter?.openAlert(self)
            }
            return cell
            
        case 1:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "PetshopSaldoProfileCell", for: indexPath) as? PetshopSaldoProfileCell
            else { return UITableViewCell() }
            return cell
            
        case 2:
            tableView.separatorStyle = .singleLine
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "PetshopEditProfileCell", for: indexPath) as? PetshopEditProfileCell
            else { return UITableViewCell() }
            return cell
            
        case 3:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "PetshopEditPasswordProfileCell", for: indexPath) as? PetshopEditPasswordProfileCell
            else { return UITableViewCell() }
            return cell
            
        default:
            tableView.separatorStyle = .none
            return UITableViewCell()
        }
    }
}

extension PetshopProfileViewController: PetshopProfileViewProtocol {
    func updateImage(image: UIImage) {
        self.imageProfile = image
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
