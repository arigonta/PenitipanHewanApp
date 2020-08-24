//
//  MonitoringModel.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 24/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

// MARK: - MonitoringAPIModel
struct MonitoringAPIModel: Codable {
    let data: [MonitoringModel]
}

// MARK: - MonitoringAPIModel
struct ReservationActionAPIModel: Codable {
    let data: MonitoringModel
}

// MARK: - MonitoringModel
struct MonitoringModel: Codable {
    let reservationPackageID: Int?
    let animalName: String?
    let animalPhoto: URL?
    let animalRacial: String?
    let age: String?
    let color: String?
    let isVaccine: Int?
    let lastTimeGotSick: String?
    let note: String?
    let petshopPackageID: Int?
    let userID: Int?
    let history: [History]?

    enum CodingKeys: String, CodingKey {
        case reservationPackageID = "reservation_package_id"
        case animalName = "animal_name"
        case animalPhoto = "animal_photo"
        case animalRacial = "animal_racial"
        case isVaccine = "is_vaccine"
        case lastTimeGotSick = "last_time_got_sick"
        case petshopPackageID = "petshop_package_id"
        case userID = "user_id"
        case age, color, note, history
    }
    
    init(reservationPackageID: Int?, animalName: String?, animalPhoto: URL?, animalRacial: String?, age: String?, color: String?, isVaccine: Int?, lastTimeGotSick: String?, note: String?, petshopPackageID: Int?, userID: Int?, history: [History]?) {
        self.reservationPackageID = reservationPackageID
        self.animalName = animalName
        self.animalPhoto = animalPhoto
        self.animalRacial = animalRacial
        self.age = age
        self.color = color
        self.isVaccine = isVaccine
        self.lastTimeGotSick = lastTimeGotSick
        self.note = note
        self.petshopPackageID = petshopPackageID
        self.userID = userID
        self.history = history
    }
}

// MARK: - History Monitoring
struct History: Codable {
    let reservationPackageHistoryID,
        reservationPackageID,
        isHasBreakfast,
        isHasLunch,
        isHasDinner,
        isHasVitamin,
        isHasVaccine,
        isHasShower: Int?
    let note,
        date: String?

    enum CodingKeys: String, CodingKey {
        case reservationPackageHistoryID = "reservation_package_history_id"
        case reservationPackageID = "reservation_package_id"
        case isHasBreakfast = "is_has_breakfast"
        case isHasLunch = "is_has_lunch"
        case isHasDinner = "is_has_dinner"
        case isHasVitamin = "is_has_vitamin"
        case isHasVaccine = "is_has_vaccine"
        case isHasShower = "is_has_shower"
        case note
        case date
    }
    
    init(reservationPackageHistoryID: Int?, reservationPackageID: Int?, isHasBreakfast: Int?, isHasLunch: Int?, isHasDinner: Int?,isHasVitamin: Int?, isHasVaccine: Int?, isHasShower: Int?, note: String?, date: String?) {
        self.reservationPackageHistoryID = reservationPackageHistoryID
        self.reservationPackageID = reservationPackageID
        self.isHasBreakfast = isHasBreakfast
        self.isHasLunch = isHasLunch
        self.isHasDinner = isHasDinner
        self.isHasVitamin = isHasVitamin
        self.isHasVaccine = isHasVaccine
        self.isHasShower = isHasShower
        self.note = note
        self.date = date
    }
}
