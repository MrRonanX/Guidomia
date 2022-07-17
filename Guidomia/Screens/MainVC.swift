//
//  MainVC.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/15/22.
//

import UIKit

final class MainVC: UIViewController {
    
    private let mainLogo        = MainPageLogo()
    private let tableView       = UITableView(frame: .zero, style: .grouped)
    private let filtersView     = FiltersView()
    private var firstLoad       = true
    
    private var backupVehicles  = [SectionModel]()
    private var vehicles        = [SectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setRightBarItem()
        setTableView()
        createTableViewHeader()
        loadVehicles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstLoad else { return }
        sectionTapped(0)
        firstLoad = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filtersView.addShadows()
    }
    
    // MARK: - Nav Bar Setup
    
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
    
    // MARK: - View Setup
    
    private func createTableViewHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 235 + view.frame.width * 0.65))
        let ratio = 0.65
        
        header.addSubview(mainLogo)
        
        NSLayoutConstraint.activate([
            mainLogo.topAnchor.constraint(equalTo: header.topAnchor),
            mainLogo.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            mainLogo.widthAnchor.constraint(equalToConstant: header.frame.width),
            mainLogo.heightAnchor.constraint(equalToConstant: header.frame.width * ratio)
        ])
        
        header.addSubview(filtersView)
        filtersView.filterTapped = filterButtonTapped
        
        NSLayoutConstraint.activate([
            filtersView.topAnchor.constraint(equalTo: mainLogo.bottomAnchor),
            filtersView.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            filtersView.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            filtersView.heightAnchor.constraint(equalToConstant: 235)
        ])
        
        tableView.tableHeaderView = header
    }
    
    private func setTableView() {
        tableView.frame = view.bounds
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(VehicleSectionCell.self, forHeaderFooterViewReuseIdentifier: VehicleSectionCell.reuseID)
        tableView.register(VehicleDetailsCell.self, forCellReuseIdentifier: VehicleDetailsCell.reuseID)
        tableView.register(SeparatorCell.self, forCellReuseIdentifier: SeparatorCell.reuseID)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        view.addSubview(tableView)
    }
    
    // MARK: - Datasource
    
    private func loadFromJson() {
        if let path = Bundle.main.path(forResource: "car_list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonData = try JSONDecoder().decode([VehicleModel].self, from: data)
                createSections(with: jsonData)
                
            } catch {
                presentAlert(with: "Error", message: "Invalid JSON. Please, check the content.", completion: nil)
            }
        }
    }
    
    private func loadVehicles() {
        PersistenceManager.retrieveVehicles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let vehicles):
                if vehicles.isEmpty {
                    self.loadFromJson()
                    return
                }
                self.createSections(with: vehicles)
                
            case .failure(let error):
                self.presentAlert(with: "Error", message: error.rawValue, completion: nil)
            }
        }
    }
    
    private func saveJson(_ data: [VehicleModel]) {
        guard let possibleError = PersistenceManager.save(vehicles: data) else { return }
        presentAlert(with: "Error", message: possibleError.rawValue, completion: nil)
    }
    
    private func createSections(with loadedVehicles: [VehicleModel]) {
        vehicles = loadedVehicles.compactMap { SectionModel(vehicle: $0)}
        backupVehicles = vehicles
        tableView.reloadData()
    }
}

// MARK: - Table View Delegate

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
}

// MARK: - Expending and Retracting Logic

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

// MARK: - Filter Logic

extension MainVC: DropdownViewDelegate {
    func filterSelected(filter: String) {
        var makeFilters = backupVehicles.map { $0.vehicle.make }
        var modelFilters = backupVehicles.map { $0.vehicle.model }
        
        makeFilters.append("Any make")
        modelFilters.append("Any model")
        
        if makeFilters.contains(filter) {
            filtersView.setMakeFilter(filter)
            filtersView.setModelFilter("Any model")
            applyMakeFilter(filter)
        } else {
            filtersView.setModelFilter(filter)
            
            if filter != "Any model" {
                filtersView.setMakeFilter(backupVehicles.filter { $0.vehicle.model == filter}.first?.vehicle.make ?? "Any make")
                applyModelFilter(filter)
            } else {
                applyMakeFilter(filtersView.currentMakeFilter)
            }
        }
    }
    
    private func filterButtonTapped(_ button: UIButton) {
        let dropdownView = DropdownView()
        dropdownView.frame = view.bounds
        let correctFrame = button.convert(button.bounds, to: view)
        view.addSubview(dropdownView)
        dropdownView.delegate = self
        dropdownView.addDatasource(getFilterList(from: button))
        dropdownView.setInitialFrame(correctFrame)
    }
    
    private func getFilterList(from button: UIButton) -> [String] {
        switch button.tag {
        case 0:
            var filterList = ["Any make"]
            filterList.append(contentsOf: backupVehicles.map { $0.vehicle.make })
            return filterList
            
        case 1:
            var filterList = ["Any model"]
            filterList.append(contentsOf: backupVehicles.map { $0.vehicle.model })
            return filterList
            
        default: return [String]()
        }
    }
    
    private func applyMakeFilter(_ filter: String) {
        guard filter != "Any make" else {
            vehicles = backupVehicles
            tableView.reloadData()
            return
        }
        
        vehicles = backupVehicles.filter { $0.vehicle.make == filter }
        tableView.reloadData()
    }
    
    private func applyModelFilter(_ filter: String) {
        guard filter != "Any model" else {
            vehicles = backupVehicles
            tableView.reloadData()
            return
        }
        
        vehicles = backupVehicles.filter { $0.vehicle.model == filter }
        tableView.reloadData()
    }
}

