//
//  ConditionsView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit



class ConditionsView: UIView{
    
    //MARK: UI Elements
    let humidity: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "humidity_icon")
        return imageView
    }()
    
    let wind: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "wind_icon")
        return imageView
    }()
    
    let pressure: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pressure_icon")
        return imageView
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.text = "45%"
        return label
    }()
    
    let windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.text = "0.7 km/h"
        return label
    }()
    
    let pressureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.text = "1024 hpa"
        return label
    }()
    
    //MARK: StackView
    
    let humidityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let windView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pressureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var conditionsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityView, windView, pressureView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
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
        
        setupStackView()
        setupConstraints()
    }
    
    //MARK: StackView setup
    func setupStackView(){
        windView.addSubview(wind)
        windView.addSubview(windLabel)
        humidityView.addSubview(humidity)
        humidityView.addSubview(humidityLabel)
        pressureView.addSubview(pressure)
        pressureView.addSubview(pressureLabel)
        
        conditionsView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        wind.topAnchor.constraint(equalTo: windView.topAnchor).isActive = true
        wind.centerXAnchor.constraint(equalTo: windView.centerXAnchor).isActive = true
        
        windLabel.centerXAnchor.constraint(equalTo: windView.centerXAnchor).isActive = true
        windLabel.bottomAnchor.constraint(equalTo: windView.bottomAnchor).isActive = true
        
        humidity.topAnchor.constraint(equalTo: humidityView.topAnchor).isActive = true
        humidity.centerXAnchor.constraint(equalTo: humidityView.centerXAnchor).isActive = true
        
        humidityLabel.centerXAnchor.constraint(equalTo: humidityView.centerXAnchor).isActive = true
        humidityLabel.bottomAnchor.constraint(equalTo: humidityView.bottomAnchor).isActive = true
        
        pressure.topAnchor.constraint(equalTo: pressureView.topAnchor).isActive = true
        pressure.centerXAnchor.constraint(equalTo: pressureView.centerXAnchor).isActive = true
        
        pressureLabel.centerXAnchor.constraint(equalTo: pressureView.centerXAnchor).isActive = true
        pressureLabel.bottomAnchor.constraint(equalTo: pressureView.bottomAnchor).isActive = true
    }
    
    //MARK: Constraints
    func setupConstraints(){
        conditionsView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        conditionsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        conditionsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        conditionsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
