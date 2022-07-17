//
//  FilterButton.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/17/22.
//

import UIKit

final class FilterButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        basicSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func basicSetup() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        backgroundColor = .white
        setDefaultTitleColor()
        contentHorizontalAlignment = .leading
        
        var config = UIButton.Configuration.plain()
        config.title = "Title"
        config.titlePadding = 10
        configuration = config
    }
    
    func setDefaultTitleColor() {
        setTitleColor(.appLightGray, for: .normal)
        setTitleColor(.appLightGray, for: .highlighted)
    }
    
    func setSelectedTitleColor() {
        setTitleColor(.black, for: .normal)
        setTitleColor(.black, for: .highlighted)
    }
}
