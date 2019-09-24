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


class HomeScreenViewModel: ViewModelType   {
    
    init(dependencies: HomeScreenViewModel.Dependencies){
        self.dependencies = dependencies
    }
    
    func transform(input: HomeScreenViewModel.Input) -> HomeScreenViewModel.Output {
        var disposables = [Disposable]()
        self.input = input
        
        disposables.append(getData(subject: input.getDataSubject))
        disposables.append(getSettings(subject: input.getSettingsSubject))
        disposables.append(getLocation(subject: input.getLocationsSubject))
        
        self.output = Output(dataIsReadySubject: PublishSubject(), locationIsMissingSubject: PublishSubject(), disposables: disposables)
        
        return output
    }
    
    struct Input {
        var getSettingsSubject: ReplaySubject<Bool>
        var getDataSubject: ReplaySubject<Bool>
        var getLocationsSubject: ReplaySubject<Bool>
        var writeToRealmSubject: PublishSubject<WriteToRealmEnum>
    }
    
    struct Output {
        var dataIsReadySubject: PublishSubject<Bool>
        var locationIsMissingSubject: PublishSubject<Bool>
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
    
    let units: String = "si"
    let location: String = "45.82176,17.39763"
    
    
    func getData(subject: ReplaySubject<Bool>) -> Disposable  {
        return subject
            .flatMap({[unowned self] bool -> Observable<MainWeatherClass> in
                let af = AlamofireRepository()
                return af.alamofireRequest(self.units, self.location)
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: {[unowned self]  bool in
                self.output.dataIsReadySubject.onNext(true)
                self.mainWeatherData = bool
            })
    }
    
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
    
    func compareDayInData(weatherData: MainWeatherClass) -> (Double, Double) {
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
    

}
