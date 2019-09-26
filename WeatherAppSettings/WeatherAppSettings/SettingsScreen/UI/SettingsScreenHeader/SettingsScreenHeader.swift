//
//  SettingsScreenHeader.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class SettingsScreenHeader: UITableViewHeaderFooterView{
    
    //MARK: UI Elements
    let title: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont(name: "GothamRounded-Book", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .clear
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: UI Setup
    func setupUI(){
        contentView.addSubview(title)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
