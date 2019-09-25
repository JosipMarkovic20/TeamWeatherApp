//
//  UnitsEnum.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
enum UnitsEnum {
    case metric
    case imperial
    
    var rawValue: String {
        switch self {
        case .metric: return "si"
        case .imperial: return "us"
        }
    }
}
