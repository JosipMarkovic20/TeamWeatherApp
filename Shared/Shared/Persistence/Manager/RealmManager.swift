//
//  RealmManager.swift
//  Shared
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift


public class RealmManager {
    
    let realm = try? Realm()
    
    public init(){}
    
    //MARK: Delete location
    public func deleteLocation(geonameId: Int) -> Observable<String>{
        guard let realmLocation = self.realm?.object(ofType: RealmLocation.self, forPrimaryKey: geonameId) else { return Observable.just("Object not found!")}
        
        do{
            try self.realm?.write {
                self.realm?.delete(realmLocation)
            }
        }catch{
            return Observable.just("Error deleting object!")
        }
        return Observable.just("Object deleted!")
    }
    
    //MARK: Save location
    public func saveLocation(location: Locations) -> Observable<String>{
        let realmLocation = RealmLocation()
        realmLocation.createRealmLocation(location: location)
        do{
            try realm?.write {
                realm?.add(realmLocation)
            }
        }catch{
            return Observable.just("Error saving object!")
        }
        return Observable.just("Object saved!")
    }
    
    //MARK: Save last location
    public func saveLastLocation(location: Locations) -> Observable<String>{
        let realmLocation = LastRealmLocation()
        realmLocation.createLastRealmLocation(location: location)
        do{
            try realm?.write {
                realm?.add(realmLocation)
            }
        }catch{
            return Observable.just("Error saving object!")
        }
        return Observable.just("Object saved!")
    }
    
    //MARK: Delete last location
    public func deleteLastLocation() -> Observable<String>{
        let backThreadRealm = try? Realm()
        guard let allLastLocations = backThreadRealm?.objects(LastRealmLocation.self) else { return Observable.just("Object not found!") }
        do{
            try backThreadRealm?.write {
                backThreadRealm?.delete(allLastLocations)
            }
        }catch{
            return Observable.just("Error deleting settings!")
        }
        return Observable.just("Settings deleted!")
    }
    
    //MARK: Get last location
    public func getLastLocation() -> Locations{
        let backThreadRealm = try! Realm()
        let lastRealmLocation = backThreadRealm.objects(LastRealmLocation.self)
        var lastLocation = Locations(lng: "", lat: "", name: "", geonameId: 0)
        for location in lastRealmLocation{
            lastLocation.lng = location.lng
            lastLocation.lat = location.lat
            lastLocation.name = location.name
            lastLocation.geonameId = location.geonameId
        }
        return lastLocation
    }
    
    //MARK: Get all locations
    public func getLocations() -> [Locations]{
        let backThreadRealm = try! Realm()
        let realmLocations = backThreadRealm.objects(RealmLocation.self)
        var locations: [Locations] = []
        for realmLocation in realmLocations{
            let location = Locations(lng: realmLocation.lng, lat: realmLocation.lat, name: realmLocation.name, geonameId: realmLocation.geonameId)
            locations.append(location)
        }
        return locations
    }
    
    
    //MARK: Delete settings
    public func deleteSettings() -> Observable<String>{
        let backThreadRealm = try? Realm()
        guard let allSettingsObjects = backThreadRealm?.objects(RealmSettings.self) else { return Observable.just("Object not found!") }
        do{
            try backThreadRealm?.write {
                backThreadRealm?.delete(allSettingsObjects)
            }
        }catch{
            return Observable.just("Error deleting settings!")
        }
        return Observable.just("Settings deleted!")
    }
    
    
    //MARK: Save settings
    public func saveSettings(settings: SettingsData) -> Observable<String>{
        let backThreadRealm = try? Realm()
        let settingsToSave = RealmSettings()
        settingsToSave.createRealmSettings(settings: settings)
        do{
            try backThreadRealm?.write {
                backThreadRealm?.add(settingsToSave)
            }
        }catch{
            return Observable.just("Error saving settings!")
        }
        return Observable.just("Settings saved!")
    }
    
    
    //MARK: Get settings
    public func getSettings() -> SettingsData{
        let backThreadRealm = try! Realm()
        let realmSettings = backThreadRealm.objects(RealmSettings.self)
        var settingsData = SettingsData(displayHumidity: true, displayWind: true, displayPressure: true, unitsType: .metric)
        for settings in realmSettings{
            settingsData.displayHumidity = settings.humidityIsHidden
            settingsData.displayPressure = settings.pressureIsHidden
            settingsData.displayWind = settings.windIsHidden
            settingsData.unitsType = settings.unitsType == "Metric" ? UnitsEnum.metric : UnitsEnum.imperial
        }
        return settingsData
    }
    
}
