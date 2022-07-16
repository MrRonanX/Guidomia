//
//  VehicleCell.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/16/22.
//

import UIKit

final class VehicleCell: UITableViewCell {
    
    static let reuseID = "VehicleCell"
    private let padding = 20.0
    
    private let vehicleImage = UIImageView()
    private let vehicleModel = UILabel()
    private let vehiclePrice = UILabel()
    private let rating = RatingView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addData(vehicle: VehicleModel) {
        vehicleImage.image = UIImage(named: vehicle.imageName)
        vehiclePrice.text = "Price: " + vehicle.displayedPrice
        vehicleModel.text = vehicle.vehicleName
        setupRating(with: vehicle.rating)
        rating.createRating(stars: vehicle.rating)
    }
    
    func setupViews() {
        backgroundColor = .appLightGray
        setupImage()
        setupModel()
        setupPrice()
        addSeparator()
    }
    
    private func setupImage() {
        vehicleImage.translatesAutoresizingMaskIntoConstraints = false
        vehicleImage.contentMode = .scaleToFill
        addSubview(vehicleImage)
        
        NSLayoutConstraint.activate([
            vehicleImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            vehicleImage.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            vehicleImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33),
            vehicleImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18)
        ])
    }
    
    private func setupModel() {
        vehicleModel.textColor = .black.withAlphaComponent(0.45)
        vehicleModel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        vehicleModel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vehicleModel)
        
        NSLayoutConstraint.activate([
            vehicleModel.leadingAnchor.constraint(equalTo: vehicleImage.trailingAnchor, constant: padding),
            vehicleModel.topAnchor.constraint(equalTo: vehicleImage.topAnchor),
            vehicleModel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    private func setupPrice() {
        vehiclePrice.textColor = .black.withAlphaComponent(0.45)
        vehiclePrice.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        vehiclePrice.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vehiclePrice)
        
        NSLayoutConstraint.activate([
            vehiclePrice.leadingAnchor.constraint(equalTo: vehicleImage.trailingAnchor, constant: padding),
            vehiclePrice.topAnchor.constraint(equalTo: vehicleModel.bottomAnchor),
            vehiclePrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    private func setupRating(with stars: Int) {
        addSubview(rating)
        
        NSLayoutConstraint.activate([
            rating.leadingAnchor.constraint(equalTo: vehicleImage.trailingAnchor, constant: padding),
            rating.topAnchor.constraint(equalTo: vehiclePrice.bottomAnchor, constant: padding / 3),
            rating.widthAnchor.constraint(equalToConstant: padding * Double(stars) + Double(stars - 1) * 10),
            rating.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    private func addSeparator() {
        let separator = SeparatorLine()
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}

fileprivate final class RatingView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    
    
    func createRating(stars: Int) {
        for _ in 0..<stars {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "star.fill")
            imageView.tintColor = .appOrange
            
            addArrangedSubview(imageView)
        }
    }
    
    
    private func baseSetup() {
        axis = .horizontal
        alignment = .leading
        distribution = .fillEqually
        spacing = 10
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
            separator.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            separator.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}
