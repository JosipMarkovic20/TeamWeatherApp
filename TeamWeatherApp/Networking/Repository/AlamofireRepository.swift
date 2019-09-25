//
//  AlamofireRepository.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift

public class AlamofireRepository {
    
    let url = "https://api.darksky.net/forecast/eed19b0a0b89a80e38d4ae15b1f24130/"
    
    func alamofireRequest(_ unit: String, _ location: String) -> Observable<MainWeatherClass> {
        let alamofireManager = AlamofireManager()
        let currentURL = url + location + "?units=" + unit
        print(currentURL)
        return alamofireManager.requestData(url: currentURL)
    }
}
