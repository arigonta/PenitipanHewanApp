//
//  ExtReservation+TableView.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

extension ReservationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let reservationCell = tableView.dequeueReusableCell(withIdentifier: "ReservationTableViewCell", for: indexPath) as? ReservationTableViewCell {
            return reservationCell
        } else {
            return UITableViewCell.init()
        }
    }
}
