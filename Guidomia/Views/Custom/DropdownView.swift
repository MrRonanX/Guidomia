//
//  DropdownView.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/17/22.
//

import UIKit

protocol DropdownViewDelegate {
    func filterSelected(filter: String)
}

final class DropdownView: UIView {
    
    private let tableView = UITableView()
    private var datasource = [String]()
    private var initialFrame = CGRect()
    var delegate: DropdownViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        backgroundColor = .black.withAlphaComponent(0.5)
        alpha = 0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gesture.delegate = self
        addGestureRecognizer(gesture)
    }
    
    private func setupTableView() {
        tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropdownCell.self, forCellReuseIdentifier: DropdownCell.reuseID)
    }
    
    func addDatasource(_ datasource: [String]) {
        self.datasource = datasource
    }
    
    func setInitialFrame(_ frame: CGRect) {
        tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
        initialFrame = frame
        addSubview(tableView)
        tableView.reloadData()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height + 5, width: frame.width, height: CGFloat(self.datasource.count * 50))
        }, completion: nil)
    }
    
    
    @objc private func viewTapped() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            
            self.alpha = 0
            self.tableView.frame = CGRect(x: self.initialFrame.origin.x, y: self.initialFrame.origin.y + self.initialFrame.height, width: self.initialFrame.width, height: 0)
            
        }) { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
    }
}

extension DropdownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.reuseID, for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.filterSelected(filter: datasource[indexPath.row])
        viewTapped()
    }
}

extension DropdownView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view?.isDescendant(of: tableView) == true ? false : true
    }
}

final class DropdownCell: UITableViewCell {
    static let reuseID = "DropdownCell"
}

