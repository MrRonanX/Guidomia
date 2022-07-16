//
//  VehicleDetailsCell.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/16/22.
//

import UIKit

final class VehicleDetailsCell: UITableViewCell {
    
    static let reuseID = "VehicleDetailsCell"
    
    private let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitle() {
        backgroundColor = .appLightGray
        title.numberOfLines = 0
        title.textAlignment = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
    }
    
    func setTitle(with text: String) {
        if text == "Pros:" || text == "Cons:" {
            title.text = text
            title.font = .systemFont(ofSize: 21, weight: .semibold)
            title.textColor = .black.withAlphaComponent(0.45)
        } else {
            let bulletText = NSAttributedStringHelper.createBulletedList(fromStringArray: text, font: .systemFont(ofSize: 18, weight: .bold))
            title.attributedText = bulletText

        }
    }
}
