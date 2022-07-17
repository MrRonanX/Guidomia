//
//  UIViewController + ext.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/17/22.
//

import UIKit

extension UIViewController {
    func presentAlert(with title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
}
