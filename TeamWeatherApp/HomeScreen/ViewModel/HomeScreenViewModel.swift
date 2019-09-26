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
        disposables.append(getSettings(subject: input.getSettingsSubject))
        disposables.append(getLocation(subject: input.getLocationsSubject))
        
        self.output = Output(dataIsReadySubject: PublishSubject(), locationIsMissingSubject: PublishSubject(),loaderSubject:  PublishSubject(),disposables: disposables)
        
        return output
    }
    
    //MARK: Defining Structs
    
    struct Input {
        var getSettingsSubject: ReplaySubject<Bool>
        var getDataSubject: ReplaySubject<Bool>
        var getLocationsSubject: ReplaySubject<Bool>
        var writeToRealmSubject: PublishSubject<WriteToRealmEnum>
    }
    
    struct Output {
        var dataIsReadySubject: PublishSubject<LayoutSetupEnum>
        var locationIsMissingSubject: PublishSubject<Bool>
        var loaderSubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        var alamofireRepository: AlamofireRepository
        var scheduler: SchedulerType
    }
    
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    var mainWeatherData: MainWeatherClass?
    
    let units: UnitsEnum = .metric
    let location: String = "45.82176,17.39763"
    
    
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
            })
    }
    //MARK: Get Settings
    func getSettings(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .flatMap({ bool -> Observable<Bool> in
                return Observable.just(bool)
            })
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
            .map({ bool in
                #warning("Ako postoje settingsi, nastavi, inace triggeraj subject za kreaciju istih")
                print("mapSettings")
            })
        .subscribe(onNext: {bool in
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
        .flatMap({ enumType -> Observable<Bool> in
            switch enumType {
            case let .location(bool):
                    #warning("create novog objekta jer je prvo zapisivanje")
                return Observable.just(bool)
            case let .settings(bool):
                if bool == true {
                    #warning("create novog objekta jer je prvo zapisivanje")
                }
                else {
                    #warning("zapisivanje uredenog objekta")
                }
                return Observable.just(bool)
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
    func convertUnits(unitType: UnitsEnum, data: MainWeatherClass) -> (currentTemperature: String, lowTemperature: String, highTemperature: String, windSpeed: String){
        let lowAndHighTemp = compareDayInData(weatherData: data)
        switch unitType {
        case .imperial:
            let currentTemperature = Double(Int((data.currently.temperature * 1.8 + 32)))
            let lowTemperature = (((lowAndHighTemp.temperatureLow * 1.8 + 32) * 10).rounded() / 10)
            let highTemperature = (((lowAndHighTemp.temperatureHigh * 1.8 + 32) * 10).rounded() / 10)
            let windSpeed = ((((data.currently.windSpeed) * 1.6 ) * 10).rounded() / 10)
            
            
            return ("\(currentTemperature)°F", "\(lowTemperature)°F", "\(highTemperature)°F", "\(windSpeed) mph")
        default:
            return ("\(Double(Int((data.currently.temperature))))°C", "\(lowAndHighTemp.temperatureLow)°C", "\(lowAndHighTemp.temperatureHigh)°C", "\(data.currently.windSpeed) km/h")
        }
    }
}
