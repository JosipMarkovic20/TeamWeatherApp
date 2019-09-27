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
        let deleteLocationSubject: PublishSubject<Int>
        let saveSettingsSubject: PublishSubject<SettingsData>
        let saveLastLocationSubject: PublishSubject<LocationsClass>
    }
    
    struct Output{
        let settingsLoadedSubject: PublishSubject<Bool>
        let popUpSubject: PublishSubject<Bool>
        var locations: [LocationsClass]
        var settings: SettingsData
        let locationDeletedSubject: PublishSubject<LocationsClass>
        let reloadRowSubject: PublishSubject<Int>
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
        disposables.append(saveSettings(for: input.saveSettingsSubject))
        disposables.append(deleteLocation(for: input.deleteLocationSubject))
        disposables.append(saveLastLocation(for: input.saveLastLocationSubject))
        
        self.output = Output(settingsLoadedSubject: PublishSubject(), popUpSubject: PublishSubject(), locations: [], settings: SettingsData(displayHumidity: true, displayWind: true, displayPressure: true, unitsType: .metric), locationDeletedSubject: PublishSubject(), reloadRowSubject: PublishSubject(), disposables: disposables)
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
                var locationsLocal = [LocationsClass]()
                for location in locations {
                    locationsLocal.append(LocationsClass(lng: location.lng, lat: location.lat, name: location.name, geoName: location.geonameId))
                }
                self.output.locations = locationsLocal
                }, onError: {[unowned self] (error) in
                    self.output.popUpSubject.onNext(true)
                    print(error)
            })
    }
    
    //MARK: Save settings
    func saveSettings(for subject: PublishSubject<SettingsData>) -> Disposable{
        return subject.flatMap({[unowned self] (settings) -> Observable<String> in
            _ = self.dependencies.realmManager.deleteSettings()
            let settings = self.dependencies.realmManager.saveSettings(settings: settings)
            return settings
        })
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {(settings) in
                print(settings)
            }, onError: {[unowned self] (error) in
                self.output.popUpSubject.onNext(true)
                print(error)
            })
    }
    
    //MARK: Delete Location
    func deleteLocation(for subject: PublishSubject<Int>) -> Disposable{
        
        return subject.flatMap({[unowned self] (location) -> Observable<String> in
            let locations = self.dependencies.realmManager.deleteLocation(geonameId: location)
            if let indexOfLocation = self.output?.locations.enumerated().first(where: {(data) -> Bool in
                data.element.geonameId == location
            }) {
                self.output.locations.remove(at: indexOfLocation.offset)
                self.output.reloadRowSubject.onNext(indexOfLocation.offset)
            }
            return locations
        })
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {(locations) in
                print(locations)
            }, onError: {[unowned self] (error) in
                self.output.popUpSubject.onNext(true)
                print(error)
            })
    }
    
    //MARK: Save last location
    func saveLastLocation(for subject: PublishSubject<LocationsClass>) -> Disposable{
        return subject.flatMap({[unowned self] (location) -> Observable<String> in
            _ = self.dependencies.realmManager.deleteLastLocation()
            let location = self.dependencies.realmManager.saveLastLocation(location: location)
            return location
        })
            .subscribeOn(dependencies.subscribeScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {(location) in
                print(location)
            }, onError: {[unowned self] (error) in
                self.output.popUpSubject.onNext(true)
                print(error)
            })
    }
}
