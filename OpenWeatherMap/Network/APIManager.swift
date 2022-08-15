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
                
                weather.main = json["weather"]["main"].stringValue
                weather.description = json["weather"]["description"].stringValue
                weather.icon = json["weather"]["icon"].stringValue
                
                weather.temp = json["main"]["temp"].doubleValue
                weather.feels_like = json["main"]["feels_like"].doubleValue
                weather.temp_min = json["main"]["temp_min"].doubleValue
                weather.temp_max = json["main"]["temp_max"].doubleValue
                weather.pressure = json["main"]["pressure"].doubleValue
                weather.humidity = json["main"]["humidity"].doubleValue
                
                completionHandler(weather)
                
                
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
}
