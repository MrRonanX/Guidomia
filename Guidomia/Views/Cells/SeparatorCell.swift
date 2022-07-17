//
//  SeparatorCell.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/16/22.
//

import UIKit

final class SeparatorCell: UITableViewCell {
    
    static let reuseID = "SeparatorCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSeparator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSeparator()
    }
    
    private func addSeparator() {
        let separator = SeparatorLine()
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
}

fileprivate final class SeparatorLine: UIView {
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       backgroundColor = .white
       translatesAutoresizingMaskIntoConstraints = false
       createSeparator()
   }
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       createSeparator()
   }
   
   private func createSeparator() {
       let separator = UIView()
       separator.backgroundColor = .appOrange
       separator.translatesAutoresizingMaskIntoConstraints = false
       
       addSubview(separator)
       
       NSLayoutConstraint.activate([
           separator.topAnchor.constraint(equalTo: topAnchor, constant: 17),
           separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
           separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
           separator.bottomAnchor.constraint(equalTo: bottomAnchor),
           separator.heightAnchor.constraint(equalToConstant: 4)
       ])
   }
}
