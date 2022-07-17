//
//  MainPageLogo.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/15/22.
//

import UIKit

final class MainPageLogo: UIView {
    
    private let padding         = 20.0
    
    private let imageView       = UIImageView()
    private let mainLabel       = UILabel()
    private let secondaryLabel  = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setViews()
    }
    
    private func setViews() {
        setBackgroundImage()
        setSecondaryLabel()
        setMainLabel()
    }
    
    private func setBackgroundImage() {
        imageView.image = UIImage(named: Images.appLogoImage)
        imageView.contentMode = .scaleToFill
        addSubview(imageView)
        
        imageView.pinToEdges(of: self)
    }
    
    private func setSecondaryLabel() {
        secondaryLabel.textColor = .white
        secondaryLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        secondaryLabel.text = "Get your's now"
        
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(secondaryLabel)
        
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            secondaryLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setMainLabel() {
        mainLabel.textColor = .white
        mainLabel.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        mainLabel.text = "Tacoma 2021"
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            mainLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor, constant: -padding / 3),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
}

