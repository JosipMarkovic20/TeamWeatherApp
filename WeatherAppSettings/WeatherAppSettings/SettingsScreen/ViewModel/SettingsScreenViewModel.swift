//
//  SettingsScreenViewModel.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift
import Shared

class SettingsScreenViewModel: ViewModelType{

    //MARK: Input/Output/Dependencies
    struct Input{
        let getLocationsSubject: PublishSubject<Bool>
        let getSettingsSubject: PublishSubject<Bool>
        let deleteLocationSubject: PublishSubject<Bool>
    }
    
    struct Output{
        let settingsLoadedSubject: PublishSubject<Bool>
        let popUpSubject: PublishSubject<Bool>
        var locations: [Locations]
        var settings: SettingsData
        let tableReloadSubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies{
        let realmManager: RealmManager
        let subscribeScheduler: SchedulerType
    }
    
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    
    
    //MARK: Init
    init(dependencies: Dependencies){
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    func transform(input: SettingsScreenViewModel.Input) -> SettingsScreenViewModel.Output {
        var disposables: [Disposable] = []
        self.input = input
        disposables.append(loadSettings(for: input.getSettingsSubject))
        disposables.append(loadLocations(for: input.getLocationsSubject))
        
        self.output = Output(settingsLoadedSubject: PublishSubject(), popUpSubject: PublishSubject(), locations: [], settings: SettingsData(displayHumidity: true, displayWind: true, displayPressure: true, unitsType: .metric), tableReloadSubject: PublishSubject(), disposables: disposables)
        return output
    }
    
    //MARK: Load settings
    func loadSettings(for subject: PublishSubject<Bool>) -> Disposable{
        
        return subject.flatMap({[unowned self] (bool) -> Observable<SettingsData> in
            let settings = self.dependencies.realmManager.getSettings()
            return Observable.just(settings)
        })
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (settings) in
                self.output.settings = settings
                self.output.settingsLoadedSubject.onNext(true)
                }, onError: {[unowned self] (error) in
                    self.output.popUpSubject.onNext(true)
                    print(error)
            })
    }
    
    //MARK: Load locations
    func loadLocations(for subject: PublishSubject<Bool>) -> Disposable{
        
        return subject.flatMap({[unowned self] (bool) -> Observable<[Locations]> in
            let locations = self.dependencies.realmManager.getLocations()
            return Observable.just(locations)
        })
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (locations) in
                self.output.locations = locations
                self.output.tableReloadSubject.onNext(true)
                }, onError: {[unowned self] (error) in
                    self.output.popUpSubject.onNext(true)
                    print(error)
            })
    }
}
