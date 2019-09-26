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
        
        conditionsView.snp.makeConstraints { (make) in
            make.height.equalTo(80)
        }
        
        wind.snp.makeConstraints { (make) in
            make.top.equalTo(windView)
            make.centerX.equalTo(windView)
        }
        
        windLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(windView)
            make.bottom.equalTo(windView)
        }
        
        humidity.snp.makeConstraints { (make) in
            make.top.equalTo(humidityView)
            make.centerX.equalTo(humidityView)
        }
        
        humidityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(humidityView)
            make.bottom.equalTo(humidityView)
        }
        
        pressure.snp.makeConstraints { (make) in
            make.top.equalTo(pressureView)
            make.centerX.equalTo(pressureView)
        }
        
        pressureLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(pressureView)
            make.bottom.equalTo(pressureView)
        }
    }
    
    //MARK: Constraints
    func setupConstraints(){
        
        conditionsView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
