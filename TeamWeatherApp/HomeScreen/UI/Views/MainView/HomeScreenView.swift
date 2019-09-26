//
//  HomeScreenView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
    
    let gradientColors = GradientColors()
    
    
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
        self.addSubview(backgroundView)
        self.addSubview(temperatureView)
        self.addSubview(locationMinAndMaxView)
        self.addSubview(conditionsView)
        self.addSubview(searchAndSettingsView)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        temperatureView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(UIScreen.main.bounds.height * 0.20)
            make.centerX.equalTo(self)
        }
        
        locationMinAndMaxView.snp.makeConstraints { (make) in
            make.top.equalTo(temperatureView.snp.bottom).offset(UIScreen.main.bounds.height * 0.25)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
        
        conditionsView.snp.makeConstraints { (make) in
            make.top.equalTo(locationMinAndMaxView.snp.bottom).offset(UIScreen.main.bounds.height * 0.25)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }

        searchAndSettingsView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
    }
    
    
    //MARK: Background setup
    func setupBackground(enumCase: LayoutSetupEnum){
        let dayGradient = [gradientColors.dayColorTop, gradientColors.dayColorBottom].gradient()
        let nightGradient = [gradientColors.nightColorTop, gradientColors.nightColorBottom].gradient()
        let rainGradient = [gradientColors.rainColorTop, gradientColors.rainColorBottom].gradient()
        let snowGradient = [gradientColors.snowColorTop, gradientColors.snowColorBottom].gradient()
        let fogGradient = [gradientColors.fogColorTop, gradientColors.fogColorBottom].gradient()
        
        switch enumCase{
        case .clearDay:
            backgroundView.bodyImage.image = UIImage(named: "body_image-clear-day")
            backgroundView.headerImage.image = UIImage(named: "header_image-clear-day")
            backgroundView.backgroundGradient.gradient = dayGradient
        case .clearNight:
            backgroundView.bodyImage.image = UIImage(named: "body_image-clear-night")
            backgroundView.headerImage.image = UIImage(named: "header_image-clear-night")
            backgroundView.backgroundGradient.gradient = nightGradient
        case .rain:
            backgroundView.bodyImage.image = UIImage(named: "body_image-rain")
            backgroundView.headerImage.image = UIImage(named: "header-image_rain")
            backgroundView.backgroundGradient.gradient = rainGradient
        case .snow:
            backgroundView.bodyImage.image = UIImage(named: "body_image-snow")
            backgroundView.headerImage.image = UIImage(named: "header_image-snow")
            backgroundView.backgroundGradient.gradient = snowGradient
        case .sleet:
            backgroundView.bodyImage.image = UIImage(named: "body_image-sleet")
            backgroundView.headerImage.image = UIImage(named: "header_image-sleet")
            backgroundView.backgroundGradient.gradient = snowGradient
        case .wind:
           backgroundView.bodyImage.image = UIImage(named: "body_image-wind")
           backgroundView.headerImage.image = UIImage(named: "header_image-wind")
           backgroundView.backgroundGradient.gradient = dayGradient
        case .fog:
            backgroundView.bodyImage.image = UIImage(named: "body_image-fog")
            backgroundView.headerImage.image = UIImage(named: "header_image-fog")
            backgroundView.backgroundGradient.gradient = fogGradient
        case .cloudy:
            backgroundView.bodyImage.image = UIImage(named: "body_image-cloudy")
            backgroundView.headerImage.image = UIImage(named: "header_image-cloudy")
            backgroundView.backgroundGradient.gradient = dayGradient
        case .partlyCloudyDay:
            backgroundView.bodyImage.image = UIImage(named: "body_image-partly-cloudy-day")
            backgroundView.headerImage.image = UIImage(named: "header_image-partly-cloudy-day")
            backgroundView.backgroundGradient.gradient = dayGradient
        case .partlyCloudyNight:
            backgroundView.bodyImage.image = UIImage(named: "body_image-partly-cloudy-night")
            backgroundView.headerImage.image = UIImage(named: "header_image-partly-cloudy-night")
            backgroundView.backgroundGradient.gradient = nightGradient
        case .hail:
            backgroundView.bodyImage.image = UIImage(named: "body_image-hail")
            backgroundView.headerImage.image = UIImage(named: "header_image-hail")
            backgroundView.backgroundGradient.gradient = rainGradient
        case .thunderstorm:
            backgroundView.bodyImage.image = UIImage(named: "body_image-thunderstorm")
            backgroundView.headerImage.image = UIImage(named: "header_image-thunderstorm")
            backgroundView.backgroundGradient.gradient = rainGradient
        case .tornado:
            backgroundView.bodyImage.image = UIImage(named: "body_image-tornado")
            backgroundView.headerImage.image = UIImage(named: "header_image-tornado")
            backgroundView.backgroundGradient.gradient = rainGradient
        }
        backgroundView.backgroundGradient.setupUI()
    }
}
