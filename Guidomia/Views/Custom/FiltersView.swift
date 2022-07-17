//
//  FiltersView.swift
//  Guidomia
//
//  Created by Roman Kavinskyi on 7/17/22.
//

import UIKit

final class FiltersView: UIView {
    
    private let padding = 20.0
    
    private let innerView = UIView()
    private let title = UILabel()
    private let makeFilterButton = FilterButton()
    private let modelFilterButton = FilterButton()
    
    var filterTapped: ((UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        modelFilterButton.layer.shadowRadius = 3
        modelFilterButton.layer.shadowOpacity = 0.7
        modelFilterButton.layer.shadowPath = UIBezierPath(rect: modelFilterButton.bounds).cgPath
    }
    
    
    
    private func setupViews() {
        backgroundColor = .white
        setupInnerView()
        setupTitle()
        setupMakeFilterButton()
        setupModelFilterButton()
    }
    
    private func setupInnerView() {
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.layer.cornerRadius = 10
        innerView.backgroundColor = .appDarkGray
        
        addSubview(innerView)
        
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            innerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            innerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            innerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    private func setupTitle() {
        title.textColor = .white
        title.font = .preferredFont(forTextStyle: .title3)
        title.text = "Filters"
        title.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: innerView.topAnchor, constant: padding / 2),
            title.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -padding),
            title.heightAnchor.constraint(equalToConstant: padding + 5)
        ])
    }
    
    private func setupMakeFilterButton() {
        makeFilterButton.setTitle("Any make", for: .normal)
        makeFilterButton.tag = 0
        makeFilterButton.addTarget(self, action: #selector(makeFilterTapped), for: .touchUpInside)
        innerView.addSubview(makeFilterButton)
        
        NSLayoutConstraint.activate([
            makeFilterButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: padding),
            makeFilterButton.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: padding),
            makeFilterButton.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -padding),
            makeFilterButton.heightAnchor.constraint(equalToConstant: padding * 2)
        ])
    }
    
    private func setupModelFilterButton() {
        modelFilterButton.setTitle("Any model", for: .normal)
        modelFilterButton.tag = 1
        modelFilterButton.addTarget(self, action: #selector(modelFilterTapped), for: .touchUpInside)
        innerView.addSubview(modelFilterButton)
        
        NSLayoutConstraint.activate([
            modelFilterButton.topAnchor.constraint(equalTo: makeFilterButton.bottomAnchor, constant: padding * 1.5),
            modelFilterButton.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: padding),
            modelFilterButton.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -padding),
            modelFilterButton.heightAnchor.constraint(equalToConstant: padding * 2),
            modelFilterButton.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -padding * 1.5)
        ])
    }
    
    func addShadows() {
        modelFilterButton.dropShadow()
        makeFilterButton.dropShadow()
    }
    
    @objc private func makeFilterTapped() {
        filterTapped?(makeFilterButton)
    }
    
    @objc private func modelFilterTapped() {
        filterTapped?(modelFilterButton)
    }
    
    func setMakeFilter(_ filter: String) {
        makeFilterButton.setTitle(filter, for: .normal)
        
        filter == "Any make" ? makeFilterButton.setDefaultTitleColor() : makeFilterButton.setSelectedTitleColor()
    }
    
    func setModelFilter(_ filter: String) {
        modelFilterButton.setTitle(filter, for: .normal)
        
        filter == "Any model" ? modelFilterButton.setDefaultTitleColor() : modelFilterButton.setSelectedTitleColor()
    }
}


