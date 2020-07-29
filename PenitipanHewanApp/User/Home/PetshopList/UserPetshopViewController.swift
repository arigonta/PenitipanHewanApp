//
//  UserPetshopViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserPetshopViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    public var petType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = petType
        setTableView()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellXib = UINib(nibName: "UserPetshopCell", bundle: nil)
        tableView.register(cellXib, forCellReuseIdentifier: "cell")
    }

}

extension UserPetshopViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension UserPetshopViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserPetshopCell
        else { return UITableViewCell() }
        
        return cell
    }
    
    
}
