//
//  WeatherModel.swift
//  OpenWeatherMap
//
//  Created by Doy Kim on 2022/08/15.
//

import Foundation


struct Weather {
    var main: String
    var description: String
    var icon: String
    
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
    
    init() {
        main = String()
        description = String()
        icon = String()
        temp = Double()
        feels_like = Double()
        temp_min = Double()
        temp_max = Double()
        pressure = Double()
        humidity = Double()
    }
}
