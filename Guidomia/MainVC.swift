//
//  MainVC.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/15/22.
//

import UIKit

class MainVC: UIViewController {
    
    private let mainLogo = MainPageLogo()
    private let tableView = UITableView()
    
    private var vehicles = [VehicleModel]() {
        didSet {
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setTitle()
        setRightBarItem()
        addImage()
        setTableView()
        decodeJson()
    }
    
    
    private func setTitle() {
        let title = UILabel()
        title.text = "GUIDOMIA"
        
        guard let customFont = UIFont(name: Fonts.stencil, size: 28) else {
            fatalError("Font is not loaded")
        }
        
        title.font = UIFontMetrics.default.scaledFont(for: customFont)
        title.adjustsFontForContentSizeCategory = true
        title.textColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
    }
    
    private func setRightBarItem() {
        let item = UIImageView()
        let config = UIImage.SymbolConfiguration(scale: .large)
        item.image = UIImage(systemName: "line.3.horizontal", withConfiguration: config)
        item.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: item)
    }
    
    private func addImage() {
        view.addSubview(mainLogo)
        
        let screenWidth = view.widthAnchor
        let ratio = 0.65
        
        NSLayoutConstraint.activate([
            mainLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLogo.widthAnchor.constraint(equalTo: screenWidth),
            mainLogo.heightAnchor.constraint(equalTo: screenWidth, multiplier: ratio)
        ])
    }
    
    private func setTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VehicleCell.self, forCellReuseIdentifier: VehicleCell.reuseID)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .appOrange
        tableView.separatorInset = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainLogo.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func decodeJson() {
        if let path = Bundle.main.path(forResource: "car_list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonData = try JSONDecoder().decode([VehicleModel].self, from: data)
                vehicles = jsonData
            } catch {
                print("Error")
            }
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vehicles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width * 0.18 + 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VehicleCell.reuseID) as! VehicleCell
        let vehicle = vehicles[indexPath.row]
        cell.setupViews()
        cell.addData(vehicle: vehicle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}


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
        vehiclePrice.text = String(vehicle.customerPrice)
        vehicleModel.text = vehicle.make
    }
    
    func setupViews() {
        backgroundColor = .appLightGray
        setupImage()
        setupModel()
        setupPrice()
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
        vehicleModel.font = UIFont.preferredFont(forTextStyle: .title1)
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
        vehiclePrice.font = UIFont.preferredFont(forTextStyle: .title3)
        vehiclePrice.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vehiclePrice)
        
        NSLayoutConstraint.activate([
            vehiclePrice.leadingAnchor.constraint(equalTo: vehicleImage.trailingAnchor, constant: padding),
            vehiclePrice.topAnchor.constraint(equalTo: vehicleModel.bottomAnchor, constant: padding / 2),
            vehiclePrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
    
    private func setupRating() {
        addSubview(rating)
        
        NSLayoutConstraint.activate([
            rating.leadingAnchor.constraint(equalTo: vehicleImage.leadingAnchor, constant: padding),
            rating.topAnchor.constraint(equalTo: vehiclePrice.bottomAnchor, constant: padding / 2),
            rating.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
}

final class RatingView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    func createRating(stars: Int) {
        axis = .horizontal
    }
    
    
}

final class SeparatorLine: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}



enum Fonts {
    static let stencil = "SairaStencilOne-Regular"
}

enum Images {
    static let appLogoImage = "Tacoma"
}





struct VehicleModel: Codable {
    let consList: [String]
    let customerPrice: Double
    let make: String
    let marketPrice: Double
    let model: String
    let prosList: [String]
    let rating: Int
    
    var imageName: String {
        switch make {
        case "Land Rover":      return "Range_Rover"
        case "Alpine":          return "Alpine_roadster"
        case "BMW":             return "BMW_330i"
        case "Mercedes Benz":   return "Mercedez_benz_GLC"
        default:                return "placeholder"
        }
    }
}
