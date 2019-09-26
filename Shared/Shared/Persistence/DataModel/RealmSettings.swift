//
//  RealmSettings.swift
//  Shared
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RealmSwift


class RealmSettings: Object{
    @objc dynamic var unitsType: String = "Metric"
    @objc dynamic var windIsHidden: Bool = false
    @objc dynamic var humidityIsHidden: Bool = false
    @objc dynamic var pressureIsHidden: Bool = false
    
    func createRealmSettings(settings: SettingsData){
        self.windIsHidden = settings.displayWind
        self.humidityIsHidden = settings.displayHumidity
        self.pressureIsHidden = settings.displayPressure
        if settings.unitsType == .metric{
            self.unitsType = "Metric"
        }else{
            self.unitsType = "Imperial"
        }
    }
}
