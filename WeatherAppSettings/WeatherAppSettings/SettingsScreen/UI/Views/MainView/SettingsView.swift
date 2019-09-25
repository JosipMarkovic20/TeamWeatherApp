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
        unitsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        unitsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        unitsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        unitsView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        conditionsView.topAnchor.constraint(equalTo: unitsView.bottomAnchor, constant: 30).isActive = true
        conditionsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        conditionsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        conditionsView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}


