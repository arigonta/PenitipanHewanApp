//
//  CommonHelper.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
       let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
       return testEmail.evaluate(with: self)
    }
    var currency: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")

        let styler = NumberFormatter()
        styler.minimumFractionDigits = 0
        styler.maximumFractionDigits = 0
        styler.currencySymbol = ""
        styler.numberStyle = .currency

        if let result = NumberFormatter().number(from: stringWithoutComma) {
            return styler.string(from: result)!
        }

        return self
    }
    
  func currencyInputFormatting() -> String {
      var number: NSNumber!
      let formatter = NumberFormatter()
      formatter.numberStyle = .currencyAccounting
      formatter.currencySymbol = "Rp."
      formatter.maximumFractionDigits = 0
      formatter.minimumFractionDigits = 0

      var amountWithPrefix = self

      // remove from String: "$", ".", ","
      let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
      amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

      let double = (amountWithPrefix as NSString).doubleValue
      number = NSNumber(value: (double))

    return formatter.string(from: number)!.replacingOccurrences(of: ",", with: ".")
    }
}
