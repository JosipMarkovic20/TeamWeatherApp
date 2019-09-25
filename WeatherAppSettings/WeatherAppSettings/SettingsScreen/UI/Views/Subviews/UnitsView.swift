//
//  UnitsView.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class UnitsView: UIView{
    
    //MARK: UI Elements
    let unitsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Book", size: 24)
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
        self.addSubview(unitsLabel)
        self.addSubview(metricCheckBox)
        self.addSubview(imperialCheckBox)
        self.addSubview(metricLabel)
        self.addSubview(imperialLabel)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        
        unitsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        imperialCheckBox.snp.makeConstraints { (make) in
            make.topMargin.equalTo(unitsLabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.02)
            make.leading.equalTo(self.snp.leading).offset(10)
            make.width.height.equalTo(40)
        }
        
        imperialLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imperialCheckBox.snp.top)
            make.leading.equalTo(imperialCheckBox.snp.trailing).offset(10)
            make.bottom.equalTo(imperialCheckBox.snp.bottom)
        }
        
        metricCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(imperialCheckBox.snp.bottom)
            make.leading.equalTo(self.snp.leading).offset(10)
            make.width.height.equalTo(40)
        }
        
        metricLabel.snp.makeConstraints { (make) in
            make.top.equalTo(metricCheckBox.snp.top)
            make.leading.equalTo(metricCheckBox.snp.trailing).offset(10)
            make.bottom.equalTo(metricCheckBox.snp.bottom)
        }   
    }
}
