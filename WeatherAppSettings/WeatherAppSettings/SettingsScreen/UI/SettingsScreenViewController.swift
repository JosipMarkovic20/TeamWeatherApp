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
import SnapKit

public class SettingsScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
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
    var settings: SettingsData
    public var settingsDelegate: SetupSettingsDelegate?
    
    
    init(viewModel: SettingsScreenViewModel, settings: SettingsData = SettingsData(displayHumidity: true, displayWind: true, displayPressure: true, unitsType: .metric)){
        self.viewModel = viewModel
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        setupUI()
        addTargets()
    }
    
    //MARK: UI Setup
    func setupUI(){
        setupBlur()
        self.view.addSubview(settingsView)
        self.view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SettingsScreenHeader.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        settingsView.doneButton.addTarget(self, action: #selector(dismissSettings), for: .touchUpInside)
        setupConstraints()
    }
    
    
    //MARK: Screen dismiss
    @objc func dismissSettings(){
        self.settings = saveSettings()
        self.settingsDelegate?.setupScreenBasedOn(settings: self.settings)
        self.dismiss(animated: true, completion: nil)
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
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(UIScreen.main.bounds.height * 0.30)
        }
        
        settingsView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(5)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    
    //MARK: TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WeatherTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WeatherTableViewCell.")
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? SettingsScreenHeader else {
            return nil
        }
        return headerView
    }
    
    //MARK: Add targets
    func addTargets(){
        settingsView.unitsView.metricCheckBox.addTarget(self, action: #selector(switchButtonState), for: .touchUpInside)
        settingsView.unitsView.imperialCheckBox.addTarget(self, action: #selector(switchButtonState), for: .touchUpInside)
        settingsView.conditionsView.humidityButton.addTarget(self, action: #selector(switchButtonState), for: .touchUpInside)
        settingsView.conditionsView.windButton.addTarget(self, action: #selector(switchButtonState), for: .touchUpInside)
        settingsView.conditionsView.pressureButton.addTarget(self, action: #selector(switchButtonState), for: .touchUpInside)
    }
    
    //MARK: Button control
    @objc func switchButtonState(button: UIButton){
        if button.tag == 0{
            settingsView.unitsView.metricCheckBox.isSelected = !settingsView.unitsView.metricCheckBox.isSelected
            settingsView.unitsView.imperialCheckBox.isSelected = !settingsView.unitsView.imperialCheckBox.isSelected
        }else if button.tag == 1{
            settingsView.unitsView.imperialCheckBox.isSelected = !settingsView.unitsView.imperialCheckBox.isSelected
            settingsView.unitsView.metricCheckBox.isSelected = !settingsView.unitsView.metricCheckBox.isSelected
        }else if button.tag == 2{
            settingsView.conditionsView.humidityButton.isSelected = !settingsView.conditionsView.humidityButton.isSelected
        }else if button.tag == 3{
            settingsView.conditionsView.windButton.isSelected = !settingsView.conditionsView.windButton.isSelected
        }else if button.tag == 4{
            settingsView.conditionsView.pressureButton.isSelected = !settingsView.conditionsView.pressureButton.isSelected
        }
    }
    
    //MARK: SaveSettings
    func saveSettings() -> SettingsData{
        var units = UnitsEnum.metric
        if settingsView.unitsView.metricCheckBox.isSelected {
            units = .metric
        }else{
            units = .imperial
        }
        let settingsData = SettingsData(displayHumidity: settingsView.conditionsView.humidityButton.isSelected,
                                        displayWind: settingsView.conditionsView.windButton.isSelected,
                                        displayPressure: settingsView.conditionsView.pressureButton.isSelected,
                                        unitsType: units)
        return settingsData
    }
    
    
    
}
