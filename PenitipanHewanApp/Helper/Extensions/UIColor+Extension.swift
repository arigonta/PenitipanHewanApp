//
//  UIColor+Extension.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 09/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    convenience init(string: String) {
        var chars = Array(string.hasPrefix("#") ? String(string.dropFirst()) : string)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        switch chars.count {
        case 3:
            chars = [chars[0], chars[0], chars[1], chars[1], chars[2], chars[2]]
            fallthrough
        case 6:
            chars = ["F", "F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            alpha = 0
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = Int(red * 255)<<16 | Int(green * 255)<<8 | Int(blue * 255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    //why this is not static since the function will return a new instance of UIColor?
//    func hexStringToUIColor(hex:String) -> UIColor {
//        return .from(hex: hex)
//    }
    
    static func from(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

public extension CGColor {
    
    static func from(hex: String) -> CGColor {
        return UIColor.from(hex: hex).cgColor
    }
}
