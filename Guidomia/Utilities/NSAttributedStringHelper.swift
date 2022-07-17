//
//  NSAttributedStringHelper.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/17/22.
//

import UIKit

enum NSAttributedStringHelper {
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
