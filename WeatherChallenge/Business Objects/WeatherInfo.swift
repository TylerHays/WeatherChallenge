//
//  weatherInfo.swift
//  WeatherChallenge
//
//  Created by Tyler Hays on 11/12/17.
//  Copyright © 2017 Timelessblur. All rights reserved.
//

import UIKit
import SwiftyJSON

class WeatherInfo {
    
    struct WeatherCoordinates {
        let latitude: Float
        let longitude: Float
        
        init(locationData:JSON) {
            latitude = locationData["lat"].floatValue
            longitude = locationData["lon"].floatValue
        }
    }
    
    struct Weather {
        let id: Int
        let main: String
        let description: String
        let iconName: String
        var icon: UIImage?
        
        init(weatherData:JSON) {
            id = weatherData["id"].intValue
            main = weatherData["main"].stringValue
            description = weatherData["description"].stringValue
            iconName = weatherData["icon"].stringValue
        }
    }
    
    struct WindData {
        let speed: Float
        let degree: Float
        
        var speedMph: Float {
            return speed * 2.23694
        }
        init(windData:JSON) {
            speed = windData["Speed"].floatValue
            degree = windData["deg"].floatValue
        }
    }
    
    struct SystemData {
        let message: Float
        let contry: String
        let sunrise: Date
        let sunset: Date
        
        init(systemData:JSON) {
            message = systemData["message"].floatValue
            contry = systemData["country"].stringValue
            sunrise = Date(timeIntervalSince1970: systemData["sunrise"].doubleValue)
            sunset = Date(timeIntervalSince1970: systemData["sunset"].doubleValue)
        }
        
    }
    
    struct MainInfo {
        let temperature: Float
        let pressure: Float
        let huminity: Float
        let temperatureMin: Float
        let temperatureMax: Float
        let seaLevelPressure: Float
        let groundLevelPressure: Float
        
        var fahrenheit: Float {
            return kelvinToFahrenheit(kelvinTemp: temperature)
        }
        
        var fahrenheitMax: Float {
            return kelvinToFahrenheit(kelvinTemp: temperatureMax)
        }
        
        var fahrenheitMin: Float {
            return kelvinToFahrenheit(kelvinTemp: temperatureMin)
        }
        
        var celsius: Float {
            return kelvinToCelsius(kelvinTemp: temperature)
        }
        
        var celsiusMin: Float {
            return kelvinToCelsius(kelvinTemp: temperatureMin)
        }
        
        var celsiusMax: Float {
            return kelvinToCelsius(kelvinTemp: temperatureMax)
        }
        
        private func kelvinToFahrenheit(kelvinTemp:Float) -> Float {
            return kelvinTemp * 9/5 - 459.67
        }
        
        private func kelvinToCelsius(kelvinTemp:Float) -> Float {
            return kelvinTemp - 273.15
        }
        
        
        init(mainData:JSON) {
            temperature = mainData["temp"].floatValue
            pressure = mainData["pressure"].floatValue
            huminity = mainData["humidity"].floatValue
            temperatureMin = mainData["temp_min"].floatValue
            temperatureMax = mainData["temp_max"].floatValue
            seaLevelPressure = mainData["sea_level"].floatValue
            groundLevelPressure = mainData["grnd_level"].floatValue
        }
    }
    
    let coordinates: WeatherCoordinates
    let weatherList: [Weather]
    let base: String
    let main: MainInfo
    let windInfo: WindData
    let cloudCover: Float
    let rainAmount: Float?
    let snowAmount: Float?
    let dateTime: Date
    let systemInfo: SystemData
    let cityId: Int
    let name: String
    let cod: Int
    
    init(weatherData:JSON) {
        
        let coordinateData = weatherData["coord"]
        coordinates = WeatherCoordinates.init(locationData: coordinateData)
        
        let weatherJsonList = weatherData["weather"].arrayValue
        var weatherDataArray: [Weather] = []
        for weatherItem in weatherJsonList {
            let weather = Weather.init(weatherData: weatherItem)
            weatherDataArray.append(weather)
        }
        weatherList = weatherDataArray
        base = weatherData["base"].stringValue
        
        let  mainData = weatherData["main"]
        main = MainInfo.init(mainData: mainData)
        
        let windData = weatherData["Wind"]
        windInfo = WindData.init(windData: windData)
        
        let systemInfoData = weatherData["sys"]
        systemInfo = SystemData.init(systemData: systemInfoData)
        
        cloudCover = weatherData["clouds"].floatValue
        rainAmount = weatherData["rain"].float
        snowAmount = weatherData["snow"].float
        
        dateTime = Date(timeIntervalSince1970: weatherData["dt"].doubleValue)
        
        cityId = weatherData["id"].intValue
        name = weatherData["name"].stringValue
        cod = weatherData["cod"].intValue
    }

}
