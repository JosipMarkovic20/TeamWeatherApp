//
//  LocationMinAndMaxView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


class LocationMinAndMaxView: UIView{
    
    //MARK: UI Elements
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Book", size: 36)
        label.text = "Virovitica"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 24)
        label.text = "15°C"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.text = "Low"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 24)
        label.text = "28°C"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.text = "High"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: StackView Elements
    let minView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let maxView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var temperatureStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [minView, divider, maxView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
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
        self.addSubview(locationLabel)
        minView.addSubview(minLabel)
        minView.addSubview(minTempLabel)
        maxView.addSubview(maxLabel)
        maxView.addSubview(maxTempLabel)
        self.addSubview(temperatureStack)
        
        setupMinAndMax()
        setupConstraints()
    }
    //MARK: Constraints
    func setupMinAndMax(){
        minTempLabel.topAnchor.constraint(equalTo: minView.topAnchor).isActive = true
        minTempLabel.centerXAnchor.constraint(equalTo: minView.centerXAnchor).isActive = true
        
        minLabel.centerXAnchor.constraint(equalTo: minView.centerXAnchor).isActive = true
        minLabel.bottomAnchor.constraint(equalTo: minView.bottomAnchor).isActive = true
        
        maxTempLabel.topAnchor.constraint(equalTo: maxView.topAnchor).isActive = true
        maxTempLabel.centerXAnchor.constraint(equalTo: maxView.centerXAnchor).isActive = true
        
        maxLabel.centerXAnchor.constraint(equalTo: maxView.centerXAnchor).isActive = true
        maxLabel.bottomAnchor.constraint(equalTo: maxView.bottomAnchor).isActive = true
        
        divider.centerXAnchor.constraint(equalTo: temperatureStack.centerXAnchor).isActive = true
        divider.topAnchor.constraint(equalTo: temperatureStack.topAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: temperatureStack.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 60).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func setupConstraints(){
        locationLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        temperatureStack.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
        temperatureStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        temperatureStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    
    
}
