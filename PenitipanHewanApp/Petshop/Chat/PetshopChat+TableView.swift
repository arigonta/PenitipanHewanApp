//
//  PetshopChat+TableView.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

extension PetshopChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let petShopChatCell = tableView.dequeueReusableCell(withIdentifier: "PetShopChatTableViewCell", for: indexPath) as? PetShopChatTableViewCell {
            return petShopChatCell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
