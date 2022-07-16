//
//  VehicleModel.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/16/22.
//

import Foundation

struct SectionModel {
    var expended = false
    let vehicle: VehicleModel
}

struct VehicleModel: Codable {
    let consList: [String]
    let customerPrice: Double
    let make: String
    let marketPrice: Double
    let model: String
    let prosList: [String]
    let rating: Int
    
    var imageName: String {
        switch make {
        case "Land Rover":      return "Range_Rover"
        case "Alpine":          return "Alpine_roadster"
        case "BMW":             return "BMW_330i"
        case "Mercedes Benz":   return "Mercedez_benz_GLC"
        default:                return "placeholder"
        }
    }
    
    var vehicleName: String {
        switch make {
        case "Land Rover":      return "Range Rover"
        case "Alpine":          return "Alpine Roadster"
        case "BMW":             return "BMW 330i"
        case "Mercedes Benz":   return make
        default:                return "placeholder"
        }
    }
    
    var displayedPrice: String {
        String(Int(customerPrice) / 1000) + "k"
    }
    
    var bulletPoints: [String] {
        var result = [String]()
        if !(prosList.filter { !$0.isEmpty }).isEmpty {
            result.append("Pros:")
            result.append(contentsOf: prosList.filter { !$0.isEmpty })
        }
        
        if !(consList.filter { !$0.isEmpty }).isEmpty {
            result.append("Cons:")
            result.append(contentsOf: consList.filter { !$0.isEmpty })
        }
        
        return result
    }
}

import UIKit

class NSAttributedStringHelper {
    static func createBulletedList(fromStringArray string: String, font: UIFont) -> NSAttributedString {
        
        let fullAttributedString = NSMutableAttributedString()
        let attributesDictionary = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.baselineOffset: NSNumber(floatLiteral: 3)] 
        
        
        let bulletPoint = NSMutableAttributedString(string: "\u{2022}  ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appOrange, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .heavy)])
        let bulletText = NSMutableAttributedString(string: string, attributes: attributesDictionary)
        fullAttributedString.append(bulletPoint)
        fullAttributedString.append(bulletText)
        
        let paragraphStyle = NSAttributedStringHelper.createParagraphAttribute()
        fullAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, fullAttributedString.length))
        
        return fullAttributedString
    }
    
    private static func createParagraphAttribute() -> NSParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 30, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.defaultTabInterval = 30
        paragraphStyle.firstLineHeadIndent = 15
        paragraphStyle.headIndent = 22
        return paragraphStyle
    }
}
