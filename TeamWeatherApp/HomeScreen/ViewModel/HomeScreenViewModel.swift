//
//  HomeScreenViewModel.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import RxCocoa
import Shared

class HomeScreenViewModel: NSObject, ViewModelType, CLLocationManagerDelegate   {
    
    init(dependencies: HomeScreenViewModel.Dependencies){
        self.dependencies = dependencies
        locationManager.requestWhenInUseAuthorization()
        super.init()
        setupLocationManager()
    }
  
    
    //MARK: Transform
    func transform(input: HomeScreenViewModel.Input) -> HomeScreenViewModel.Output {
        var disposables = [Disposable]()
        self.input = input
        
        disposables.append(getData(subject: input.getDataSubject))
        disposables.append(loadSettings(for: input.getSettingsSubject))
        disposables.append(getLocation(subject: input.getLocationsSubject))
        disposables.append(writeToRealm(subject: input.writeToRealmSubject))
        
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
    }
    
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    var mainWeatherData: MainWeatherDataClass?
    var locationData: LocationsClass!
    let locationManager = CLLocationManager()
    
    var units: UnitsEnum = .metric
    
    
    //MARK: Get Data
    func getData(subject: ReplaySubject<Bool>) -> Disposable  {
        return subject
            .flatMap({[unowned self] bool -> Observable<MainWeatherModel> in
                self.output.loaderSubject.onNext(true)
                let location = self.locationData.lat + "," + self.locationData.lng
                return self.dependencies.alamofireRepository.alamofireRequest(location)
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  bool in
                var dailyLocalArray = [DailyDataStruct]()
                for daily in bool.daily.data {
                    dailyLocalArray.append(DailyDataStruct(temperatureHigh: daily.temperatureHigh, temperatureLow: daily.temperatureLow, time: daily.time))
                }
                self.mainWeatherData = MainWeatherDataClass(currently: CurrentlyStruct(time: bool.currently.time, summary: bool.currently.summary, icon: bool.currently.icon, temperature: bool.currently.temperature, humidity: bool.currently.humidity, pressure: bool.currently.pressure, windSpeed: bool.currently.windSpeed), daily: DailyStruct(data: dailyLocalArray))
                self.setupCurrentWeatherState(weatherDataIcon: bool.currently.icon)
                self.output.loaderSubject.onNext(false)
                self.input.getSettingsSubject.onNext(true)
            },  onError: {[unowned self] (error) in
                    self.output.popUpSubject.onNext(true)
                    print(error)
            })
    }

    //MARK: Get Location
    func getLocation(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .flatMap({ [unowned self] bool -> Observable<Locations> in
                
                return self.dependencies.realmManager.getLastLocation()
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .map({ bool in
                if bool.geonameId != 0 {
                    self.locationData = LocationsClass(lng: bool.lng, lat: bool.lat, name: bool.name, geoName: bool.geonameId)
                    self.input.getDataSubject.onNext(true)
                }
                else {
                    self.locationManager.startUpdatingLocation()
                }
            })
            .subscribe(onNext: {bool in
                
            },  onError: {[unowned self] (error) in
                    self.output.popUpSubject.onNext(true)
                    print(error)
            }
        )
    }
    //MARK: Write To Realm
    func writeToRealm(subject: PublishSubject<WriteToRealmEnum>) -> Disposable {
        return subject
        .flatMap({ [unowned self]enumType -> Observable<(String, String)> in
            switch enumType {
            case .location(_):
                return Observable.zip(self.dependencies.realmManager.saveLocation(location: self.locationData), Observable.just(""))
            case let .settings(bool):
                if bool == true {
                }
                else {
                }
                return Observable.zip(Observable.just("bool"), Observable.just(""))
            case .lastLocation(_):
                return Observable.zip(self.dependencies.realmManager.deleteLastLocation(), self.dependencies.realmManager.saveLastLocation(location: self.locationData))
                
                
            }
        })
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .map({ bool in
            print("mapLocations")
        })
        .subscribe(onNext: {bool in
            print(bool)
        },  onError: {[unowned self] (error) in
                self.output.popUpSubject.onNext(true)
                print(error)
        })
    }
    //MARK: Compare Day In Data
    func compareDayInData(weatherData: MainWeatherDataClass) -> (temperatureLow: Double, temperatureHigh: Double) {
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
                },  onError: {[unowned self] (error) in
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
    func convertUnits(unitType: UnitsEnum, data: MainWeatherDataClass) -> (currentTemperature: String, lowTemperature: String, highTemperature: String, windSpeed: String, humidity: String, pressure: String){
        let lowAndHighTemp = compareDayInData(weatherData: data)
        switch unitType {
        case .imperial:
            let currentTemperature = Double((data.currently.temperature * 1.8 + 32))
            let lowTemperature = (((lowAndHighTemp.temperatureLow * 1.8 + 32) * 10).rounded() / 10)
            let highTemperature = (((lowAndHighTemp.temperatureHigh * 1.8 + 32) * 10).rounded() / 10)
            let windSpeed = ((((data.currently.windSpeed) / 1.6 ) * 10).rounded() / 10)
            
            
            return ("\(Int(currentTemperature))°", "\(lowTemperature)°F", "\(highTemperature)°F", "\(windSpeed) mph", "\(Int(data.currently.humidity * 100))%", "\(Int(data.currently.pressure)) hpa")
        default:
            return ("\(Int((data.currently.temperature)))°", "\(lowAndHighTemp.temperatureLow)°C", "\(lowAndHighTemp.temperatureHigh)°C", "\(data.currently.windSpeed) km/h", "\(Int(data.currently.humidity * 100))%", "\(Int(data.currently.pressure)) hpa")
        }
    }
    
    //MARK: SetupLocationManager
      func setupLocationManager(){
          if CLLocationManager.locationServicesEnabled() {
              locationManager.delegate = self
              locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
          }
      }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: {[unowned self](placemarks, error) in
            
            self.locationData = LocationsClass(lng: String(locValue.longitude), lat: String(locValue.latitude), name: placemarks?[0].locality ?? "Ne moze bas tolko..", geoName: 1)
            self.locationManager.stopUpdatingLocation()
            self.input.writeToRealmSubject.onNext(.lastLocation(true))
            self.input.getDataSubject.onNext(true)
        })
        
    }
    
    
}
