//
//  ViewModelType.swift
//  TeamWeatherApp
//
//  Created by Josip Marković on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Dependencies
    
    func transform(input: Input) -> Output
}
