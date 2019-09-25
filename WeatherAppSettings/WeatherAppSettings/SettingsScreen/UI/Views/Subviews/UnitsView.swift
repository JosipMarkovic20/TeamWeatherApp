//
//  UnitsView.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit



class UnitsView: UIView{
    
    //MARK: UI Elements
    let unitsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 24)
        label.text = "Units"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let metricCheckBox: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSelected = true
        button.setImage(UIImage(named: "square_checkmark_check"), for: .selected)
        button.setImage(UIImage(named: "square_checkmark_uncheck"), for: .normal)
        return button
    }()
    
    let metricLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.text = "Metric"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imperialCheckBox: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSelected = false
        button.setImage(UIImage(named: "square_checkmark_check"), for: .selected)
        button.setImage(UIImage(named: "square_checkmark_uncheck"), for: .normal)
        return button
    }()
    
    let imperialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.text = "Imperial"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI Setup
    func setupUI(){
        self.addSubview(unitsLabel)
        self.addSubview(metricCheckBox)
        self.addSubview(imperialCheckBox)
        self.addSubview(metricLabel)
        self.addSubview(imperialLabel)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        unitsLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        unitsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        imperialCheckBox.topAnchor.constraint(equalTo: unitsLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
        imperialCheckBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        imperialCheckBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imperialCheckBox.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        imperialLabel.topAnchor.constraint(equalTo: imperialCheckBox.topAnchor).isActive = true
        imperialLabel.leadingAnchor.constraint(equalTo: imperialCheckBox.trailingAnchor, constant: 10).isActive = true
        imperialLabel.bottomAnchor.constraint(equalTo: imperialCheckBox.bottomAnchor).isActive = true
        
        metricCheckBox.topAnchor.constraint(equalTo: imperialCheckBox.bottomAnchor).isActive = true
        metricCheckBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        metricCheckBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
        metricCheckBox.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        metricLabel.topAnchor.constraint(equalTo: metricCheckBox.topAnchor).isActive = true
        metricLabel.leadingAnchor.constraint(equalTo: metricCheckBox.trailingAnchor, constant: 10).isActive = true
        metricLabel.bottomAnchor.constraint(equalTo: metricCheckBox.bottomAnchor).isActive = true
        
        
    }
}
