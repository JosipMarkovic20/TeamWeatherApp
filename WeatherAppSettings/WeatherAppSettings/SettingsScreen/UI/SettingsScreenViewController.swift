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
    
    
    var viewModel: SettingsScreenViewModel
    public weak var settingsDelegate: SetupSettingsDelegate?
    let disposeBag = DisposeBag()
    public weak var coordinatorDelegate: CoordinatorDelegate?
    public weak var openLocationDelegate: OpenLocationFromSettingsDelegate?
    
    //MARK: Init
    init(viewModel: SettingsScreenViewModel){
        self.viewModel = viewModel
        let input = SettingsScreenViewModel.Input(getLocationsSubject: PublishSubject(), getSettingsSubject: PublishSubject(), deleteLocationSubject: PublishSubject(), saveSettingsSubject: PublishSubject(), saveLastLocationSubject: PublishSubject())
        let output = viewModel.transform(input: input)
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinit: \(self)")
    }
    
    //MARK: Lifecycle methods
    override public func viewDidLoad() {
        setupUI()
        addTargets()
        setupSubscriptions()
        viewModel.input.getSettingsSubject.onNext(true)
        viewModel.input.getLocationsSubject.onNext(true)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinatorDelegate?.viewControllerHasFinished()
    }
    
    //MARK: UI Setup
    func setupUI(){
        setupBlur()
        self.view.addSubview(settingsView)
        self.view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsScreenTableCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SettingsScreenHeader.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        settingsView.doneButton.addTarget(self, action: #selector(dismissSettings), for: .touchUpInside)
        setupConstraints()
    }
    
    
    //MARK: Screen dismiss
    @objc func dismissSettings(){
        self.viewModel.output.settings = saveSettings()
        self.settingsDelegate?.setupScreenBasedOn(settings: self.viewModel.output.settings)
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
        return viewModel.output.locations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SettingsScreenTableCell  else {
            fatalError("The dequeued cell is not an instance of SettingsScreenTableCell.")
        }
        cell.geonameId = viewModel.output.locations[indexPath.row].geonameId
        cell.configureCell(name: viewModel.output.locations[indexPath.row].name)
        cell.deleteLocationDelegate = self
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? SettingsScreenHeader else {
            return nil
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openLocationDelegate?.openLocation(location: viewModel.output.locations[indexPath.row])
        viewModel.input.saveLastLocationSubject.onNext(viewModel.output.locations[indexPath.row])
        self.dismiss(animated: true, completion: nil)
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
        viewModel.input.saveSettingsSubject.onNext(settingsData)
        return settingsData
    }
    
    //MARK: LoadSettings
    func settingsLoaded(){
        settingsView.conditionsView.humidityButton.isSelected = viewModel.output.settings.displayHumidity
        settingsView.conditionsView.windButton.isSelected = viewModel.output.settings.displayWind
        settingsView.conditionsView.pressureButton.isSelected = viewModel.output.settings.displayPressure
        if viewModel.output.settings.unitsType == .metric{
            settingsView.unitsView.metricCheckBox.isSelected = true
            settingsView.unitsView.imperialCheckBox.isSelected = false
        }else{
            settingsView.unitsView.metricCheckBox.isSelected = false
            settingsView.unitsView.imperialCheckBox.isSelected = true
        }
    }
    
    //MARK: Subscriptions
    func setupSubscriptions(){
        viewModel.output.settingsLoadedSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (enumCase) in
                self.settingsLoaded()
            }).disposed(by: disposeBag)
        
        viewModel.output.reloadRowSubject
        .observeOn(MainScheduler.instance)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {[unowned self] (row) in
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }).disposed(by: disposeBag)
        
        viewModel.output.popUpSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.showPopUp()
            }).disposed(by: disposeBag)
    }
    
    //MARK: PopUp
    func showPopUp(){
        let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
}


extension SettingsScreenViewController: DeleteLocationDelegate{
    
    public func deleteLocation(geonameId: Int) {
        viewModel.input.deleteLocationSubject.onNext(geonameId)
    }
  
}
