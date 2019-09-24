//
//  TemperatureView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

class TemperatureView: UIView{
    //MARK: UI Elements
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 72)
        label.text = "24°"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 24)
        label.text = "Sunny"
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
        self.addSubview(temperatureLabel)
        self.addSubview(summaryLabel)
        
        setupConstraints()
    }
    //MARK: Constraints
    func setupConstraints(){
        temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        summaryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        summaryLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor).isActive = true
    }
}
