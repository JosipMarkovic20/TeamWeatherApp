//
//  LocationRepository.swift
//  WeatherAppSearch
//
//  Created by Josip Marković on 25/09/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import Shared


class LocationRepository {
    let url = "http://api.geonames.org/searchJSON?q="
    let username = "&maxRows=10&username=myCRObaM"
    
    func alamofireRequest(_ location: String) -> Observable<SearchDataModel> {
        let alamofireManager = LocationAlamofireManager()
        let currentURL = url + location + username
        return alamofireManager.requestLocation(url: currentURL)
    }
}
