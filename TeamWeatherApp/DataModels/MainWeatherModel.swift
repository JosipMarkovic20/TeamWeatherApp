//
//  MainWeatherClass.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


class MainWeatherModel: Decodable {
    var currently: Currently
    let daily: Daily
}

struct Currently: Decodable {
    let time: Int
    let summary: String
    let icon: String
    let temperature: Double
    var humidity: Double
    let pressure: Double
    let windSpeed: Double
}

struct Daily: Decodable {
    let data: [DailyData]
}
struct DailyData: Decodable {
    let temperatureHigh: Double
    let temperatureLow: Double
    let time: Int
}

class MainWeatherDataClass {
    var currently: CurrentlyStruct
    let daily: DailyStruct
    
    init(currently: CurrentlyStruct, daily: DailyStruct) {
        self.currently = currently
        self.daily = daily
    }
}

struct CurrentlyStruct {
    let time: Int
    let summary: String
    let icon: String
    let temperature: Double
    var humidity: Double
    let pressure: Double
    let windSpeed: Double
}

struct DailyStruct {
    let data: [DailyDataStruct]
}
struct DailyDataStruct {
    let temperatureHigh: Double
    let temperatureLow: Double
    let time: Int
}
