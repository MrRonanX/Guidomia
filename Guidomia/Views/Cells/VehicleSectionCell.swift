//
//  VehicleCell.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/16/22.
//

import UIKit

protocol VehicleSectionCellDelegate {
    func sectionTapped(_ section: Int)
}

final class VehicleSectionCell: UITableViewHeaderFooterView {
    
    static let reuseID = "VehicleSectionCell"
    private let padding = 20.0
    
    private let vehicleImage = UIImageView()
    private let vehicleModel = UILabel()
    private let vehiclePrice = UILabel()
    private var rating = RatingView()
    
    private var section: Int?
    private var ratingWidthConstraint: NSLayoutConstraint?
    
    var delegate: VehicleSectionCellDelegate?
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    func addData(vehicle: VehicleModel, section: Int) {
        self.section = section
        vehicleImage.image = UIImage(named: vehicle.imageName)
        vehiclePrice.text = "Price: " + vehicle.displayedPrice
        vehicleModel.text = vehicle.vehicleName
        setupRating(with: vehicle.rating)
        rating.createRating(stars: vehicle.rating)
    }
    
    func setupViews() {
        contentView.backgroundColor = .appLightGray
        setupImage()
        setupModel()
        setupPrice()
        addGestureRecognizer()
    }
    
    private func setupImage() {
        let screenWidth = UIScreen.main.bounds.width
        vehicleImage.translatesAutoresizingMaskIntoConstraints = false
        vehicleImage.contentMode = .scaleToFill
        contentView.addSubview(vehicleImage)
        
        NSLayoutConstraint.activate([
            vehicleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            vehicleImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            vehicleImage.widthAnchor.constraint(equalToConstant: screenWidth * 0.33),
            vehicleImage.heightAnchor.constraint(equalToConstant: screenWidth * 0.18)
        ])
    }
    
    private func setupModel() {
        vehicleModel.textColor = .black.withAlphaComponent(0.45)
        vehicleModel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        vehicleModel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vehicleModel)
        
        NSLayoutConstraint.activate([
            vehicleModel.leadingAnchor.constraint(equalTo: vehicleImage.trailingAnchor, constant: padding),
            vehicleModel.topAnchor.constraint(equalTo: vehicleImage.topAnchor),
            vehicleModel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func setupPrice() {
        vehiclePrice.textColor = .black.withAlphaComponent(0.45)
        vehiclePrice.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        vehiclePrice.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vehiclePrice)
        
        NSLayoutConstraint.activate([
            vehiclePrice.leadingAnchor.constraint(equalTo: vehicleImage.trailingAnchor, constant: padding),
            vehiclePrice.topAnchor.constraint(equalTo: vehicleModel.bottomAnchor),
            vehiclePrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func setupRating(with stars: Int) {
        rating.removeFromSuperview()
        rating = RatingView()
        rating.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rating)
        
        NSLayoutConstraint.activate([
            rating.leadingAnchor.constraint(equalTo: vehicleImage.trailingAnchor, constant: padding),
            rating.topAnchor.constraint(equalTo: vehiclePrice.bottomAnchor, constant: padding / 3),
            rating.widthAnchor.constraint(equalToConstant: padding * Double(stars) + Double(stars) * 10),
            rating.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    private func addGestureRecognizer() {
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped))
        addGestureRecognizer(gesture)
    }
    
    @objc private func sectionTapped() {
        guard let section = section else { return }
        delegate?.sectionTapped(section)

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
        arrangedSubviews.forEach { $0.removeFromSuperview() }
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

 
