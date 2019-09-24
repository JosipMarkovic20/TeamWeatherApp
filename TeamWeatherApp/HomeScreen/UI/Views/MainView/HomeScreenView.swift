//
//  HomeScreenView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


class HomeScreenView: UIView {
    
    //MARK: Views
    let backgroundView: BackgroundView = {
        let view = BackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let temperatureView: TemperatureView = {
        let view = TemperatureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationMinAndMaxView: LocationMinAndMaxView = {
        let view = LocationMinAndMaxView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let conditionsView: ConditionsView = {
        let view = ConditionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchAndSettingsView: SearchAndSettingsView = {
        let view = SearchAndSettingsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        self.addSubview(backgroundView)
        self.addSubview(temperatureView)
        self.addSubview(locationMinAndMaxView)
        self.addSubview(conditionsView)
        self.addSubview(searchAndSettingsView)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        temperatureView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIScreen.main.bounds.height * 0.20).isActive = true
        temperatureView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        locationMinAndMaxView.topAnchor.constraint(equalTo: temperatureView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.25).isActive = true
        locationMinAndMaxView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        locationMinAndMaxView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        conditionsView.topAnchor.constraint(equalTo: locationMinAndMaxView.bottomAnchor, constant: UIScreen.main.bounds.height * 0.25).isActive = true
        conditionsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        conditionsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        searchAndSettingsView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchAndSettingsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        searchAndSettingsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
