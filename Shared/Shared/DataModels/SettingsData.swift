//
//  SettingsData.swift
//  Shared
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


public struct SettingsData{
    

    public var displayHumidity: Bool
    public var displayWind: Bool
    public var displayPressure: Bool
    public var unitsType: UnitsEnum
    
    public init(displayHumidity: Bool, displayWind: Bool, displayPressure: Bool, unitsType: UnitsEnum){
        self.displayHumidity = displayHumidity
        self.displayWind = displayWind
        self.displayPressure = displayPressure
        self.unitsType = unitsType
    }
    
}
