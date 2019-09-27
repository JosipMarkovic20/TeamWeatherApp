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
   public var lng: String
    public var lat: String
    public var name: String
    public var geonameId: Int
}

public class LocationsClass {
    public var lng: String
    public var lat: String
    public var name: String
    public var geonameId: Int
    
    public init(lng: String, lat: String, name: String, geoName: Int){
        self.lng = lng
        self.lat = lat
        self.name = name
        self.geonameId = geoName
    }
}
