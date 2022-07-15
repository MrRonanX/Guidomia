//
//  UIColor + ext.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/15/22.
//

import UIKit

extension UIColor {
    
    static func colorFromHex(_ hex: String) -> UIColor {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        return self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                         alpha: 1.0)
    }
    
    static var appOrange: UIColor {
        colorFromHex("#FC6016")
    }
    
    static var appLightGray: UIColor {
        colorFromHex("#D5D5D5")
    }
    
    static var appDarkGray: UIColor {
        colorFromHex("#858585")
    }
}
