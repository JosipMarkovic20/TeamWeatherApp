//
//  SettingsView.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import Hue


class SettingsView: UIView{
    
    //MARK: Views
    let unitsView: UnitsView = {
        let view = UnitsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let conditionsView: ConditionsView = {
        let view = ConditionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(hex: "#6DA133"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        return button
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
        self.addSubview(unitsView)
        self.addSubview(conditionsView)
        self.addSubview(doneButton)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        
        unitsView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(120)
        }

        conditionsView.snp.makeConstraints { (make) in
            make.top.equalTo(unitsView.snp.bottom).offset(30)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(120)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.trailing.equalTo(self).offset(-10)
            make.width.equalTo(90)
            make.height.equalTo(40)
        }
    }
    
}


