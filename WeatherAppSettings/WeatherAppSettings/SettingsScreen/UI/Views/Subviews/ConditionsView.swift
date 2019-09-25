//
//  ConditionsView.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit




class ConditionsView: UIView{
    
    //MARK: UI Elements
    
    let conditionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Conditions"
        label.font = UIFont(name: "GothamRounded-Book", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidity: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "humidity_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let wind: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wind_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let pressure: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pressure_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let humidityView: UIView = {
        let humidityView = UIView()
        humidityView.translatesAutoresizingMaskIntoConstraints = false
        humidityView.backgroundColor = .clear
        return humidityView
    }()
    
    let windView: UIView = {
        let humidityView = UIView()
        humidityView.translatesAutoresizingMaskIntoConstraints = false
        humidityView.backgroundColor = .clear
        return humidityView
    }()
    
    let pressureView: UIView = {
        let humidityView = UIView()
        humidityView.translatesAutoresizingMaskIntoConstraints = false
        humidityView.backgroundColor = .clear
        return humidityView
    }()
    
    let humidityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "checkmark_check"), for: .selected)
        button.setImage(UIImage(named: "checkmark_uncheck"), for: .normal)
        button.isSelected = true
        button.tag = 1
        return button
    }()
    
    let windButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "checkmark_check"), for: .selected)
        button.setImage(UIImage(named: "checkmark_uncheck"), for: .normal)
        button.isSelected = true
        button.tag = 2
        return button
    }()
    
    let pressureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "checkmark_check"), for: .selected)
        button.setImage(UIImage(named: "checkmark_uncheck"), for: .normal)
        button.isSelected = true
        button.tag = 3
        return button
    }()

    
    lazy var conditionsView: UIStackView = {
        let conditionsView = UIStackView(arrangedSubviews: [humidityView, windView, pressureView])
        conditionsView.translatesAutoresizingMaskIntoConstraints = false
        conditionsView.axis = .horizontal
        conditionsView.spacing = 20
        conditionsView.distribution = .fillEqually
        return conditionsView
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
        self.addSubview(conditionsView)
        self.addSubview(conditionsLabel)
        humidityView.addSubview(humidity)
        humidityView.addSubview(humidityButton)
        pressureView.addSubview(pressure)
        pressureView.addSubview(pressureButton)
        windView.addSubview(wind)
        windView.addSubview(windButton)
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        setupConditions()
        
        conditionsLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        conditionsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        conditionsView.topAnchor.constraint(equalTo: conditionsLabel.bottomAnchor, constant: 10).isActive = true
        conditionsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        conditionsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        conditionsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupConditions(){
        wind.topAnchor.constraint(equalTo: windView.topAnchor).isActive = true
        wind.centerXAnchor.constraint(equalTo: windView.centerXAnchor).isActive = true
        
        windButton.centerXAnchor.constraint(equalTo: windView.centerXAnchor).isActive = true
        windButton.bottomAnchor.constraint(equalTo: windView.bottomAnchor, constant: 10).isActive = true
        windButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        windButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        humidity.topAnchor.constraint(equalTo: humidityView.topAnchor).isActive = true
        humidity.centerXAnchor.constraint(equalTo: humidityView.centerXAnchor).isActive = true
        
        humidityButton.bottomAnchor.constraint(equalTo: humidityView.bottomAnchor, constant: 10).isActive = true
        humidityButton.centerXAnchor.constraint(equalTo: humidityView.centerXAnchor).isActive = true
        humidityButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        humidityButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        pressure.topAnchor.constraint(equalTo: pressureView.topAnchor).isActive = true
        pressure.centerXAnchor.constraint(equalTo: pressureView.centerXAnchor).isActive = true
        
        pressureButton.bottomAnchor.constraint(equalTo: pressureView.bottomAnchor, constant: 10).isActive = true
        pressureButton.centerXAnchor.constraint(equalTo: pressureView.centerXAnchor).isActive = true
        pressureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pressureButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
