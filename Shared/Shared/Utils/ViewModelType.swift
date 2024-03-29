//
//  ViewModelType.swift
//  Shared
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Dependencies
    
    func transform(input: Input) -> Output
}
