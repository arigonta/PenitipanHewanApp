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
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let reservationCell = tableView.dequeueReusableCell(withIdentifier: "ReservationTableViewCell", for: indexPath) as? ReservationTableViewCell {
            reservationCell.delegate = self
            reservationCell.indexPath = indexPath
            return reservationCell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension ReservationViewController: ReservationVCtoCellProtocol {
    func accept(_ indexPath: IndexPath) {
        self.openAlert(title: "Are you sure?",
                       message: "Press Accept, to continue.",
                       alertStyle: .alert,
                       actionTitles: ["Cancel", "Accept"],
                       actionStyles: [.default, .cancel],
                       actions: [
                        {_ in
                            print("cancel click")
                        },
                        {_ in
                            self.dummyData.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                            self.tableView.reloadData()
                            print("accept click")
                        }
        ])
    }
    
    func decline(_ indexPath: IndexPath) {
        self.openAlert(title: "Are you sure?",
                       message: "Press Ok, to decline.",
                       alertStyle: .alert,
                       actionTitles: ["Ok", "Cancel"],
                       actionStyles: [.destructive, .default],
                       actions: [
                        {_ in
                            self.dummyData.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                            self.tableView.reloadData()
                            print("Ok click")
                        },
                        {_ in
                            print("Cancel click")
                        }
        ])
    }
}
