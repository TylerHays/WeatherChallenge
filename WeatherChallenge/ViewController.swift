//
//  ViewController.swift
//  WeatherChallenge
//
//  Created by Tyler Hays on 11/12/17.
//  Copyright © 2017 Timelessblur. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    var weatherInfo: WeatherInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let preferences = UserDefaults.standard
       
        if let weatherLocation = preferences.string(forKey: "WeatherLocation") {
            if (!weatherLocation.isEmpty) {
                locationTextField.text = weatherLocation
                updateWeatherLocation(with: weatherLocation)
            }
        }
    }
    
    // if more time would of moved this to session code to utility function with data blocks
    func updateWeatherLocation(with location:String) {
        let session = URLSession.shared
        guard let urlRequest = ConnectionUtility.getWeatherRequest(location: location) else {
            return;
        }
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard  error == nil else {
                return
            }
            
            guard let responseData = data else {
                return
            }
           
            let json = JSON(data: responseData)
            let weatherInfo = WeatherInfo(weatherData: json)
            
            //hack done for time reasons as we know it error with this key
            if (weatherInfo.cityId == 0) {
                let errorMessage = json["message"].stringValue
                DispatchQueue.main.async {
                    self.setupErrorView(errorMessage: errorMessage)
                }
                
            }
            DispatchQueue.main.async {
                self.setupView(weatherInfo: weatherInfo)
            }
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(location, forKey: "WeatherLocation")
            userDefaults.synchronize()
            
        }
        task.resume()
        
    }
    
    //function is not as clean as normal. Would be cleaned up in future coding to make the setups a lot cleaner
    func setupErrorView(errorMessage:String) {
        instructionView.isHidden = false;
        weatherDetailView.isHidden = true
        errorMessageLabel.text = errorMessage
    }
    
    func setupView(weatherInfo:WeatherInfo) {
        
        //A hack done for time as this should cause an error
        if (weatherInfo.cityId == 0) {
            weatherDetailView.isHidden = true
            instructionView.isHidden = false
            return
        }
        instructionView.isHidden = true
        weatherDetailView.isHidden = false;
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyy HH:mm:ss'"
        self.weatherInfo = weatherInfo
        locationLabel.text = weatherInfo.name
        lastUpdatedLabel.text = formatter.string(from: weatherInfo.dateTime)
        currentTempLabel.text = "\(weatherInfo.main.fahrenheit.rounded()) F"
        highTempLabel.text = "\(weatherInfo.main.fahrenheitMax.rounded()) F"
        lowTempLabel.text = "\(weatherInfo.main.fahrenheitMin.rounded()) F"
        humitityLabel.text = "\(weatherInfo.main.huminity.rounded())%"
        windSpeedLabel.text = "\(weatherInfo.windInfo.speedMph) mph"
        windDirectionLabel.text = "\(weatherInfo.windInfo.degree)"
        self.weatherTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showWeather(_ sender: Any) {
        guard let city = locationTextField.text else {
            return
        }
        updateWeatherLocation(with: city)
    }
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var humitityLabel: UILabel!
    @IBOutlet weak var weatherDetailView: UIView!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weather = self.weatherInfo  else {
            return 0
        }
        return weather.weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherTableViewCell else {
            return UITableViewCell() //should never happen
        }
        guard let weatherInfo = self.weatherInfo else {
            return UITableViewCell() // Should never happen
        }
        let weather = weatherInfo.weatherList[indexPath.row]
        cell.setupCell(with: weather)
        return cell
        
    }
    
    
}
