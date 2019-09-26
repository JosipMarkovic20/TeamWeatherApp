//
//  LocationMinAndMaxView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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
        
        minTempLabel.snp.makeConstraints { (make) in
            make.top.equalTo(minView)
            make.centerX.equalTo(minView)
        }
        
        minLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(minView)
            make.bottom.equalTo(minView)
        }
        
        maxTempLabel.snp.makeConstraints { (make) in
            make.top.equalTo(maxView)
            make.centerX.equalTo(maxView)
        }
        
        maxLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(maxView)
            make.bottom.equalTo(maxView)
        }
        
        divider.snp.makeConstraints { (make) in
            make.centerX.equalTo(temperatureStack)
            make.top.equalTo(temperatureStack)
            make.bottom.equalTo(temperatureStack)
            make.height.equalTo(60)
            make.width.equalTo(3)
        }
    }
    
    func setupConstraints(){
        
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        
        temperatureStack.snp.makeConstraints { (make) in
            make.top.equalTo(locationLabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.05)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
    }
}
