//
//  AlamofireRepository.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift

class AlamofireRepository {
    
    let url = "https://api.darksky.net/forecast/eed19b0a0b89a80e38d4ae15b1f24130/"
    
    func alamofireRequest(_ location: String) -> Observable<MainWeatherModel> {
        let alamofireManager = AlamofireManager()
        let currentURL = url + location + "?units=si"
        print(currentURL)
        return alamofireManager.requestData(url: currentURL)
    }
}
