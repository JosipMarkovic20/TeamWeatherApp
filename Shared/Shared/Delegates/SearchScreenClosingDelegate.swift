//
//  SearchScreenClosingDelegate.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 27/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation

public protocol SearchScreenClosingDelegate: class {
    func screenWillClose(location: LocationsClass)
}
