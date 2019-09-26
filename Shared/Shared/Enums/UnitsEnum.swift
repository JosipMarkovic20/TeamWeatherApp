//
//  UnitsEnum.swift
//  Shared
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


public enum UnitsEnum {
    case metric
    case imperial
    
    public var rawValue: String {
        switch self {
        case .metric: return "si"
        case .imperial: return "us"
        }
    }
}
