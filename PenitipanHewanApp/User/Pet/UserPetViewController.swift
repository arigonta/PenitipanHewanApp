//
//  UserPetViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserPetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTable()
    }

}

// MARK: - table
extension UserPetViewController {
    private func setTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibCell = UINib(nibName: "userPetListCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")
    }
}

extension UserPetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UserPetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? userPetListCell
        else { return UITableViewCell() }
        
        return cell
    }
}
