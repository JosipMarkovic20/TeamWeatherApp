//
//  SearchDataModel.swift
//  Shared
//
//  Created by Josip Marković on 26/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


public class SearchDataModel: Decodable {
    public let geonames: [Locations]
}

public struct Locations: Decodable {
    public let lng: String
    public let lat: String
    public let name: String
    public let geonameId: Int
    public let countryCode: String
}
