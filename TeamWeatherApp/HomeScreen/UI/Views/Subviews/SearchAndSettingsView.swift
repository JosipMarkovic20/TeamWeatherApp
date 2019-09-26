//
//  SearchAndSettingsView.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class SearchAndSettingsView: UIView{
    
    //MARK: UI Elements
    let settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "settings_icon"), for: .normal)
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search"
        return searchBar
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
        self.addSubview(settingsButton)
        self.addSubview(searchBar)
        
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        
        settingsButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.leading.equalTo(self).offset(30)
            make.width.equalTo(24)
            make.height.equalTo(56)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(self)
            make.leading.equalTo(settingsButton.snp.trailing).offset(10)
            make.trailing.equalTo(self).offset(-10)
        }        
    }
}
