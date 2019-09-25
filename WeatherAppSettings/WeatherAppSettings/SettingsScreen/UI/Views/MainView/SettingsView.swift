//
//  SettingsView.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


class SettingsView: UIView{
    
    //MARK: Views
    let unitsView: UnitsView = {
        let view = UnitsView()
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
        self.addSubview(unitsView)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        unitsView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        unitsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        unitsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        unitsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
}


