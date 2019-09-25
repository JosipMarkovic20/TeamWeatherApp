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
    
    init(viewModel: HomeScreenViewModel){
        self.viewModel = viewModel
        let input = HomeScreenViewModel.Input(getSettingsSubject: ReplaySubject.create(bufferSize: 1), getDataSubject: ReplaySubject.create(bufferSize: 1), getLocationsSubject: ReplaySubject.create(bufferSize: 1), writeToRealmSubject: PublishSubject())
        let output = viewModel.transform(input: input)
        for disposable in output.disposables{
            disposable.disposed(by: disposeBag)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        homeScreenView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        homeScreenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        homeScreenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        homeScreenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
    
    func setupScreenData(enumCase: LayoutSetupEnum){
        
        guard let weatherData = viewModel.mainWeatherData else { return }
        let roundedVaules = viewModel.roundingCorrection(weatherData: weatherData)
        let units = viewModel.unitSettings(currentUnits: viewModel.units)
        
        homeScreenView.temperatureView.temperatureLabel.text = "\(roundedVaules.temperatureValue)°"
        homeScreenView.temperatureView.summaryLabel.text = weatherData.currently.summary
        
        let minAndMax: (Double, Double) = viewModel.compareDayInData(weatherData: weatherData)
        homeScreenView.locationMinAndMaxView.minTempLabel.text = "\(minAndMax.0)\(units.temperatureUnit)"
        homeScreenView.locationMinAndMaxView.maxTempLabel.text = "\(minAndMax.1)\(units.temperatureUnit)"
        
        homeScreenView.conditionsView.humidityLabel.text = "\(roundedVaules.humidityValue)%"
        homeScreenView.conditionsView.windLabel.text = "\(weatherData.currently.windSpeed) \(units.speedUnit)"
        homeScreenView.conditionsView.pressureLabel.text = "\(Int(weatherData.currently.pressure)) hpa"
        
        homeScreenView.setupBackground(enumCase: enumCase)
    }
    
    
    //MARK: Subscriptions
    
    func setupSubscriptions(){
        
        viewModel.output.dataIsReadySubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (enumCase) in
                self.setupScreenData(enumCase: enumCase)
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
    }
}
