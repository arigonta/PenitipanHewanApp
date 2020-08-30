//
//  ExtReservation+TableView.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import Kingfisher

extension ReservationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataReservation?.count ?? 0) == 0 ? 1 : dataReservation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCount = dataReservation?.count ?? 0
        
        if dataCount == 0 {
            tableView.separatorStyle = .none
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationListEmptyCell", for: indexPath) as? ReservationListEmptyCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            tableView.separatorStyle = .singleLine
            guard let reservationCell = tableView.dequeueReusableCell(withIdentifier: "ReservationTableViewCell", for: indexPath) as? ReservationTableViewCell, let data = dataReservation?[indexPath.row] else {
                return UITableViewCell()
            }
            
            reservationCell.delegate = self
            reservationCell.indexPath = indexPath
            reservationCell.namePet.text = data.animalName
            reservationCell.labelLastTimeGotSick.text = data.lastTimeGotSick
            reservationCell.labelDesc.text = (data.note ?? "").isEmpty ? "Tidak Pernah Sakit" : data.note
            reservationCell.labelVaccine.text = (data.isVaccine ?? 0) == 0 ? "Belum": "Sudah"
            
            if let photo = data.animalPhoto, !photo.isEmpty {
                let url = URL(string: photo)
                reservationCell.imagePet.kf.setImage(with: url)
            }
            
            return reservationCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
                            guard let data = self.dataReservation?[indexPath.row], let resPackageId = data.reservationPackageID else { return }
                            let param: [String: Any] = ["action": "approved",
                                                        "reservation_package_id": resPackageId]
                            self.postActionReservation(param: param)
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
                            guard let data = self.dataReservation?[indexPath.row], let resPackageId = data.reservationPackageID else { return }
                            let param: [String: Any] = ["action": "declined",
                                                        "reservation_package_id": resPackageId]
                            self.postActionReservation(param: param)
                            print("Ok click")
                        },
                        {_ in
                            print("Cancel click")
                        }
        ])
    }
}
