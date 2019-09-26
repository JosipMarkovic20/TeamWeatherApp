//
//  SettingsData.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import Shared

public struct SettingsData{
    

    public let displayHumidity: Bool
    public let displayWind: Bool
    public let displayPressure: Bool
    public let unitsType: UnitsEnum
    
    public init(displayHumidity: Bool, displayWind: Bool, displayPressure: Bool, unitsType: UnitsEnum){
        self.displayHumidity = displayHumidity
        self.displayWind = displayWind
        self.displayPressure = displayPressure
        self.unitsType = unitsType
    }
    
}
