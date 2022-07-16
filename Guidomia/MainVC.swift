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
        
        tableView.separatorStyle = .none
        
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
        view.frame.width * 0.18 + 40 + 24
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









