//
//  UIView + ext.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/15/22.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func dropShadow() {
        let shadowSize: CGFloat = 20
        let height = bounds.height
        let width = bounds.width
        let contactRect = CGRect(x: 0,
                                 y: height - (shadowSize * 0.7),
                                 width: width,
                                 height: shadowSize)
       layer.shadowPath = UIBezierPath(rect: contactRect) .cgPath
       layer.shadowRadius = 2
       layer.shadowOpacity = 0.4
    }

}
