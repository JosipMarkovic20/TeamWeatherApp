//
//  SettingsScreenViewController.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Shared

class SettingsScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: UI Elements
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()
    
    let settingsView: SettingsView = {
        let view = SettingsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let viewModel: SettingsScreenViewModel
    
    
    init(viewModel: SettingsScreenViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    //MARK: UI Setup
    func setupUI(){
        setupBlur()
        self.view.addSubview(settingsView)
        self.view.addSubview(tableView)
      
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setupConstraints()
    }
    
    //MARK: Blurred background
    func setupBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    
    
    //MARK: Constraints
    func setupConstraints(){
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.28).isActive = true
        
        settingsView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5).isActive = true
        settingsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        settingsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        settingsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WeatherTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WeatherTableViewCell.")
        }

        return cell
    }
    
}
