//
//  CommonHelper.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

class CommonHelper {
    static let shared = CommonHelper()
    let isLogin = "isLoggedIn"
    let lastRole = "lastRole"
    let BASE_URL = "http://api.rynetta.web.id/public/"
    let LOGIN_PATH = "user/login"
    let REGISTER_PATH = "user/register"
    static let dummyPetshopId = "TESTCHAT_PETSHOP"
    
    private let formatter = DateFormatter()

    // MARK: - Methods
    public func dateToString(from date: Date) -> String {
        configureDateFormatter(for: date)
        return formatter.string(from: date)
    }

    public func dateToAttributedString(from date: Date, with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let dateString = dateToString(from: date)
        return NSAttributedString(string: dateString, attributes: attributes)
    }

    open func configureDateFormatter(for date: Date) {
        formatter.locale = .init(identifier: "id")
        switch true {
        case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .short
            formatter.timeStyle = .short
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            formatter.dateFormat = "EEEE h:mm a"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
            formatter.dateFormat = "E, d MMM, h:mm a"
        default:
            formatter.dateFormat = "MMM d, yyyy, h:mm a"
        }
    }
    
    func convertDateToDuration(input: String) -> Int {
        if input.contains("7") {
            return 7
        } else if input.contains("2") {
            return 14
        } else {
            return 30
        }
    }
    
    func convertCurrencyToNumerics(input: String) -> Int {
        return Int(input.filter("0123456789.".contains).replacingOccurrences(of: ".", with: "", options: .literal, range: nil)) ?? 0
    }
    
    func convertIntToBool(input: Int) -> Bool {
        if input == 0 {
            return false
        } else {
            return true
        }
    }
    
    func convertBoolToInt(input: Bool) -> Int {
        if input == false {
            return 0
        } else {
            return 1
        }
    }
}
