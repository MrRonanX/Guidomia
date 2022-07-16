//
//  MainVC.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/15/22.
//

import UIKit

class MainVC: UIViewController {
    
    private let mainLogo = MainPageLogo()
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var firstLoad = true
    
    private var vehicles = [SectionModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setTitle()
        setRightBarItem()
        addImage()
        setTableView()
        decodeJson()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstLoad else { return }
        sectionTapped(0)
        firstLoad = false
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
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VehicleSectionCell.self, forHeaderFooterViewReuseIdentifier: VehicleSectionCell.reuseID)
        tableView.register(VehicleDetailsCell.self, forCellReuseIdentifier: VehicleDetailsCell.reuseID)
        tableView.register(SeparatorCell.self, forCellReuseIdentifier: SeparatorCell.reuseID)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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
                vehicles = jsonData.compactMap { SectionModel(vehicle: $0)}
                tableView.reloadData()

            } catch {
                print("Error")
            }
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        vehicles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = vehicles[section]
        return section.expended ? section.vehicle.bulletPoints.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = vehicles[indexPath.section]
        
        if !section.expended || (section.expended && section.vehicle.bulletPoints.count == indexPath.row) {
            return 21
        }
        
        let row = section.vehicle.bulletPoints[indexPath.row]
        return row.height(forConstrainedWidth: view.frame.width - 60, font: .systemFont(ofSize: 21, weight: .semibold)) + 16
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        view.frame.width * 0.18 + 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = vehicles[indexPath.section]
        
        if !section.expended || (section.expended && section.vehicle.bulletPoints.count == indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeparatorCell.reuseID) as! SeparatorCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VehicleDetailsCell.reuseID) as! VehicleDetailsCell
        
        let cellText = section.vehicle.bulletPoints[indexPath.row]
        cell.setTitle(with: cellText)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: VehicleSectionCell.reuseID) as! VehicleSectionCell
        let currentSection = vehicles[section]
        
        sectionView.addData(vehicle: currentSection.vehicle, section: section)
        sectionView.delegate = self
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension MainVC: VehicleSectionCellDelegate {
    func sectionTapped(_ section: Int) {
        vehicles[section].expended.toggle()
        let vehicle = vehicles[section]
        let indexPaths = (0..<vehicle.vehicle.bulletPoints.count).map { IndexPath(row: $0, section: section) }
        
        vehicle.expended ? sectionIsOpened(at: indexPaths) : sectionIsClosed(at: indexPaths)
    }
    
    
    func sectionIsClosed(at indexPath: [IndexPath]) {
        guard let section = indexPath.first?.section else { return }
        tableView.deleteRows(at: indexPath, with: .fade)
        tableView.reloadSections([section], with: .fade)
    }
    
    func sectionIsOpened(at indexPath: [IndexPath]) {
        guard let section = indexPath.first?.section else { return }
        
        tableView.insertRows(at: indexPath, with: .fade)
        tableView.reloadSections([section], with: .fade)
        closeOtherSections(except: section)
        
    }
    
    func closeOtherSections(except section: Int) {
        var expendedSection = section
        for i in 0..<vehicles.count {
            if i == section { continue }
            if vehicles[i].expended {
                vehicles[i].expended = false
                expendedSection = i
                break
            }
        }
        
        guard expendedSection != section else { return }
        
        let vehicle = vehicles[expendedSection]
        let indexPaths = (0..<vehicle.vehicle.bulletPoints.count).map { IndexPath(row: $0, section: expendedSection) }
        sectionIsClosed(at: indexPaths)
    }
}












