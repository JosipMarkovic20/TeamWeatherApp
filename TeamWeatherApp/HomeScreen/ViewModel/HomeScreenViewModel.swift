//
//  HomeScreenViewModel.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Shared

class HomeScreenViewModel: ViewModelType{
    
    init(dependencies: HomeScreenViewModel.Dependencies){
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    func transform(input: HomeScreenViewModel.Input) -> HomeScreenViewModel.Output {
        var disposables = [Disposable]()
        self.input = input
        
        disposables.append(getData(subject: input.getDataSubject))
        disposables.append(loadSettings(for: input.getSettingsSubject))
        disposables.append(getLocation(subject: input.getLocationsSubject))
        
        self.output = Output(dataIsReadySubject: PublishSubject(), locationIsMissingSubject: PublishSubject(),loaderSubject:  PublishSubject(), settings: SettingsData(displayHumidity: true, displayWind: true, displayPressure: true, unitsType: .metric), settingsLoadedSubject: PublishSubject(), popUpSubject: PublishSubject(),disposables: disposables)
        
        return output
    }
    
    //MARK: Defining Structs
    
    struct Input {
        var getSettingsSubject: PublishSubject<Bool>
        var getDataSubject: ReplaySubject<Bool>
        var getLocationsSubject: ReplaySubject<Bool>
        var writeToRealmSubject: PublishSubject<WriteToRealmEnum>
    }
    
    struct Output {
        var dataIsReadySubject: PublishSubject<LayoutSetupEnum>
        var locationIsMissingSubject: PublishSubject<Bool>
        var loaderSubject: PublishSubject<Bool>
        var settings: SettingsData
        let settingsLoadedSubject: PublishSubject<Bool>
        let popUpSubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        var alamofireRepository: AlamofireRepository
        var realmManager: RealmManager
        var scheduler: SchedulerType
        let realmManager: RealmManager
    }
    
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    var mainWeatherData: MainWeatherClass?
    var locationData: Locations!
    
    var units: UnitsEnum = .metric
    var location: String = "45.82176,17.39763"
    var locationName: String = "Virovitica"
    
    
    //MARK: Get Data
    func getData(subject: ReplaySubject<Bool>) -> Disposable  {
        return subject
            .flatMap({[unowned self] bool -> Observable<MainWeatherClass> in
                self.output.loaderSubject.onNext(true)
                return self.dependencies.alamofireRepository.alamofireRequest(self.units.rawValue, self.location)
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  bool in
                self.mainWeatherData = bool
                self.setupCurrentWeatherState(weatherDataIcon: bool.currently.icon)
                self.output.loaderSubject.onNext(false)
                self.input.getSettingsSubject.onNext(true)
            })
    }

    //MARK: Get Location
    func getLocation(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .flatMap({ bool -> Observable<Bool> in
                return Observable.just(bool)
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .map({ bool in
                #warning("Ako postoje locationi, nastavi, inace triggeraj subject za kreaciju istih")
                print("mapLocations")
            })
            .subscribe(onNext: {bool in
            })
    }
    //MARK: Write To Realm
    func writeToRealm(subject: PublishSubject<WriteToRealmEnum>) -> Disposable {
        return subject
        .flatMap({ enumType -> Observable<String> in
            switch enumType {
            case let .location(bool):
                return self.dependencies.realmManager.saveLocation(location: self.locationData)
            case let .settings(bool):
                if bool == true {
                    #warning("create novog objekta jer je prvo zapisivanje")
                }
                else {
                    #warning("zapisivanje uredenog objekta")
                }
                return Observable.just("bool")
            }
        })
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .map({ bool in
            print("mapLocations")
        })
        .subscribe(onNext: {bool in
        })
    }
    //MARK: Compare Day In Data
    func compareDayInData(weatherData: MainWeatherClass) -> (temperatureLow: Double, temperatureHigh: Double) {
        var temperature = (0.9, 1.1)
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(weatherData.currently.time)) as Date)
        
        for day in weatherData.daily.data {
            let searchDay = calendar.component(.day, from: NSDate(timeIntervalSince1970: Double(day.time)) as Date)
            if currentDay == searchDay {
                temperature.0 = ((day.temperatureLow * 10).rounded() / 10)
                temperature.1 = ((day.temperatureHigh * 10).rounded() / 10)
            }
        }
        return temperature
    }
    
    //MARK: Load settings
    func loadSettings(for subject: PublishSubject<Bool>) -> Disposable{
        return subject.flatMap({[unowned self] (bool) -> Observable<SettingsData> in
            let settings = self.dependencies.realmManager.getSettings()
            return Observable.just(settings)
        })
            .subscribeOn(dependencies.scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (settings) in
                self.output.settings = settings
                self.output.settingsLoadedSubject.onNext(true)
                }, onError: {[unowned self] (error) in
                    self.output.popUpSubject.onNext(true)
                    print(error)
            })
    }
    
    
    //MARK: Setup Current Weather State
    func setupCurrentWeatherState(weatherDataIcon: String) {
        switch weatherDataIcon {
        case "clear-day":
            output.dataIsReadySubject.onNext(.clearDay)
        case "clear-night":
            output.dataIsReadySubject.onNext(.clearNight)
        case "rain":
            output.dataIsReadySubject.onNext(.rain)
        case "snow":
            output.dataIsReadySubject.onNext(.snow)
        case "sleet":
            output.dataIsReadySubject.onNext(.sleet)
        case "wind":
            output.dataIsReadySubject.onNext(.wind)
        case "fog":
            output.dataIsReadySubject.onNext(.fog)
        case "cloudy":
            output.dataIsReadySubject.onNext(.cloudy)
        case "partly-cloudy-day":
            output.dataIsReadySubject.onNext(.partlyCloudyDay)
        case "partly-cloudy-night":
            output.dataIsReadySubject.onNext(.partlyCloudyNight)
        case "hail":
            output.dataIsReadySubject.onNext(.hail)
        case "thunderstorm":
            output.dataIsReadySubject.onNext(.thunderstorm)
        case "tornado":
            output.dataIsReadySubject.onNext(.tornado)
        default:
            output.dataIsReadySubject.onNext(.clearDay)
        }
    }
    
    //MARK: Unit Coversion function
    func convertUnits(unitType: UnitsEnum, data: MainWeatherClass) -> (currentTemperature: String, lowTemperature: String, highTemperature: String, windSpeed: String, humidity: String, pressure: String){
        let lowAndHighTemp = compareDayInData(weatherData: data)
        switch unitType {
        case .imperial:
            let currentTemperature = Double((data.currently.temperature * 1.8 + 32))
            let lowTemperature = (((lowAndHighTemp.temperatureLow * 1.8 + 32) * 10).rounded() / 10)
            let highTemperature = (((lowAndHighTemp.temperatureHigh * 1.8 + 32) * 10).rounded() / 10)
            let windSpeed = ((((data.currently.windSpeed) / 1.6 ) * 10).rounded() / 10)
            
            
            return ("\(Int(currentTemperature))°", "\(lowTemperature)°F", "\(highTemperature)°F", "\(windSpeed) mph", "\(data.currently.humidity * 100)%", "\(Int(data.currently.pressure)) hpa")
        default:
            return ("\(Int((data.currently.temperature)))°", "\(lowAndHighTemp.temperatureLow)°C", "\(lowAndHighTemp.temperatureHigh)°C", "\(data.currently.windSpeed) km/h", "\(data.currently.humidity * 100)%", "\(Int(data.currently.pressure)) hpa")
        }
    }
}
