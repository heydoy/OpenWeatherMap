//
//  APIManager.swift
//  OpenWeatherMap
//
//  Created by Doy Kim on 2022/08/15.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    private init() {}
    static let shared = APIManager()
    
    func callWeather(lat: Double, lon: Double, completionHandler: @escaping (Weather) -> Void) {
        
        let url = ENDPOINT.OPEN_WEATHER
        let parameter: Parameters = [
            "lat" : lat,
            "lon" : lon,
            "appid" : KEYS.OPEN_WEATHER
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseData { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                print(json)
                
                var weather = Weather()
                
                let weatherInfo = json["weather"].arrayValue[0]
                
                weather.name = json["name"].stringValue
                weather.id = weatherInfo["id"].intValue
                weather.main = weatherInfo["main"].stringValue
                weather.description = weatherInfo["description"].stringValue
                weather.icon = weatherInfo["icon"].stringValue
                print(weather.icon)
                
                weather.temp = json["main"]["temp"].doubleValue - 273
                weather.feels_like = json["main"]["feels_like"].doubleValue - 273
                weather.temp_min = json["main"]["temp_min"].doubleValue - 273
                weather.temp_max = json["main"]["temp_max"].doubleValue - 273
                weather.pressure = json["main"]["pressure"].doubleValue
                weather.humidity = json["main"]["humidity"].doubleValue
                
                completionHandler(weather)
                
                
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
}
