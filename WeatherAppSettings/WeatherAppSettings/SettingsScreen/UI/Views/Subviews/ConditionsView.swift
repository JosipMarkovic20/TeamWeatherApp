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
    
    //MARK: Init
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
        
        conditionsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        
        conditionsView.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsLabel.snp.bottom).offset(10)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
    }
    
    func setupConditions(){
        
        wind.snp.makeConstraints { (make) in
            make.top.equalTo(windView)
            make.centerX.equalTo(windView)
        }
        
        windButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(windView)
            make.bottom.equalTo(windView).offset(10)
            make.width.height.equalTo(40)
        }
        
        humidity.snp.makeConstraints { (make) in
            make.top.equalTo(humidityView)
            make.centerX.equalTo(humidityView)
        }
        
        humidityButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(humidityView)
            make.bottom.equalTo(humidityView).offset(10)
            make.width.height.equalTo(40)
        }

        pressure.snp.makeConstraints { (make) in
            make.top.equalTo(pressureView)
            make.centerX.equalTo(pressureView)
        }
        
        pressureButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(pressureView)
            make.bottom.equalTo(pressureView).offset(10)
            make.width.height.equalTo(40)
        }
    }
}
