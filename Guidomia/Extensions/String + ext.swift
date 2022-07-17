//
//  String + ext.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/16/22.
//

import UIKit

extension String {
    func height(forConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return boundingBox.height
    }
}
