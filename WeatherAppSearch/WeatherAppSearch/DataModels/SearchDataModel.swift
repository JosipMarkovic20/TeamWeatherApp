//
//  SearchDataModel.swift
//  WeatherAppSearch
//
//  Created by Matej Hetzel on 26/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation


class SearchDataModel: Decodable {
    let geonames: [Locations]
}

struct Locations: Decodable {
    let lng: String
    let lat: String
    let name: String
    let countryCode: String
}
