//
//  HomeScreenViewController.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Shared
import SnapKit
import WeatherAppSettings

class HomeScreenViewController: UIViewController, UISearchBarDelegate{
    
    //MARK: Views
    let homeScreenView: HomeScreenView = {
        let view = HomeScreenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchAndSettingsView.settingsButton.addTarget(self, action: #selector(openSettingsScreen), for: .touchUpInside)
        return view
    }()
    
    
    //MARK: Properties
    let viewModel: HomeScreenViewModel
    let disposeBag = DisposeBag()
    var openSettingsDelegate: OpenSettingsDelegate?
    let loader = LoaderViewController()
    var openSearchDelegate: OpenSearchDelegate?
    
    
    //MARK: Init
    init(viewModel: HomeScreenViewModel){
        self.viewModel = viewModel
        let input = HomeScreenViewModel.Input(getSettingsSubject: PublishSubject(), getDataSubject: ReplaySubject.create(bufferSize: 1), getLocationsSubject: ReplaySubject.create(bufferSize: 1), writeToRealmSubject: PublishSubject())
        let output = viewModel.transform(input: input)
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        setupSubscriptions()
        setupUI()
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSearchBar()
    }
    
    //MARK: UI Setup
    func setupUI(){
        self.view.addSubview(homeScreenView)
        
        homeScreenView.searchAndSettingsView.searchBar.delegate = self
        setupConstraints()
    }
    
    //MARK: Constraints
    func setupConstraints(){
        
        homeScreenView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    
    //MARK: Search bar methods
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        openSearchScreen(searchBar)
        return false
    }
    
    func openSearchScreen(_ searchBar: UISearchBar){
        openSearchDelegate?.openSearch(searchBar: searchBar)
    }
    
    func setupSearchBar(){
        let searchTextField = homeScreenView.searchAndSettingsView.searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "search_icon")!
        let imageView:UIImageView = UIImageView.init(image: image)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(hex: "#6DA133")
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextField.ViewMode.always
        
        if let backgroundview = searchTextField.subviews.first {
            backgroundview.layer.cornerRadius = 18;
            backgroundview.clipsToBounds = true;
        }
    }
    
    
    //MARK: Settings screen methods
    
    @objc func openSettingsScreen(){
        openSettingsDelegate?.openSettings()
    }
    
    //MARK: Get data
    
    func getData(){
        viewModel.input.getDataSubject.onNext(true)
    }
    
    //MARK: Setup screen
    
    func setupScreenData(){
        
        guard let weatherData = viewModel.mainWeatherData else { return }
        let screenData = viewModel.convertUnits(unitType: viewModel.units, data: weatherData)
        
        homeScreenView.locationMinAndMaxView.locationLabel.text = viewModel.locationName
        
        homeScreenView.temperatureView.temperatureLabel.text = screenData.currentTemperature
        homeScreenView.temperatureView.summaryLabel.text = weatherData.currently.summary
        
        homeScreenView.locationMinAndMaxView.minTempLabel.text = screenData.lowTemperature
        homeScreenView.locationMinAndMaxView.maxTempLabel.text = screenData.highTemperature
        
        homeScreenView.conditionsView.humidityLabel.text = screenData.humidity
        homeScreenView.conditionsView.windLabel.text = screenData.windSpeed
        homeScreenView.conditionsView.pressureLabel.text = screenData.pressure
    }
    
    
    //MARK: Subscriptions
    
    func setupSubscriptions(){
        
        viewModel.output.dataIsReadySubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (enumCase) in
                self.homeScreenView.setupBackground(enumCase: enumCase)
                self.setupScreenData()
            }).disposed(by: disposeBag)
        
        viewModel.output.loaderSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).subscribe(onNext: { [unowned self] (bool) in
                if bool{
                    self.addChild(self.loader)
                    self.loader.view.frame = self.view.frame
                    self.view.addSubview(self.loader.view)
                    self.loader.didMove(toParent: self)
                }else{
                    self.loader.willMove(toParent: nil)
                    self.loader.view.removeFromSuperview()
                    self.loader.removeFromParent()
                }
                }, onError: { (error) in
                    print("Error displaying loader ", error)
            }).disposed(by: disposeBag)
        
        viewModel.output.settingsLoadedSubject
        .observeOn(MainScheduler.instance)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {[unowned self] (enumCase) in
            self.setupScreenBasedOn(settings: self.viewModel.output.settings)
        }).disposed(by: disposeBag)
    }
}

//MARK: Settings delegate
extension HomeScreenViewController: SetupSettingsDelegate{
    
    func setupScreenBasedOn(settings: SettingsData) {
        self.homeScreenView.conditionsView.humidityView.isHidden = !settings.displayHumidity
        self.homeScreenView.conditionsView.windView.isHidden = !settings.displayWind
        self.homeScreenView.conditionsView.pressureView.isHidden = !settings.displayPressure
        self.viewModel.units = settings.unitsType
        setupScreenData()
    }
    
}

extension HomeScreenViewController: SearchScreenClosingDelegate {
    func screenWillClose(location: Locations) {
        let geoLocation = location.lat + "," + location.lng
        viewModel.location = geoLocation
        viewModel.locationName = location.name
        viewModel.input.getDataSubject.onNext(true)
    }
}
