//
//  MainWeatherClass.swift
//  TeamWeatherApp
//
//  Created by Matej Hetzel on 24/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


class MainWeatherClass: Decodable {
    let currently: Currently
    let daily: Daily
}

struct Currently: Decodable {
    let time: Int
    let summary: String
    let icon: String
    let temperature: Double
    let humidity: Double
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
