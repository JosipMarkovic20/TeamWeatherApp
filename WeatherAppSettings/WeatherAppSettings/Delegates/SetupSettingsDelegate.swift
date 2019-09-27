//
//  SetupSettingsDelegate.swift
//  WeatherAppSettings
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import Shared

public protocol SetupSettingsDelegate: class{
    func setupScreenBasedOn(settings: SettingsData)
}
