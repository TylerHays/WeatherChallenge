//
//  ConnectionUtility.swift
//  WeatherChallenge
//
//  Created by Tyler Hays on 11/12/17.
//  Copyright © 2017 Timelessblur. All rights reserved.
//

import Foundation

class ConnectionUtility {
    static  func  getWeatherRequest(location:String) -> URLRequest? {
        let weatherURL =  weatherAPIUrl + "/data/2.5/weather?q=\(location)&APPID=\(weatherAPIKey)"
        
        guard let url = URL(string:weatherURL) else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    static func getWeatherIconRequest(iconName:String) -> URLRequest? {
        let weatherIconUrl = "https://openweathermap.org/img/w/\(iconName).png"
        guard let url = URL(string:weatherIconUrl) else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}
