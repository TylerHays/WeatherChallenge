//
//  WeatherTableViewCell.swift
//  WeatherChallenge
//
//  Created by Tyler Hays on 11/12/17.
//  Copyright © 2017 Timelessblur. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(with weather:WeatherInfo.Weather) {
        self.weatherDescriptionLabel.text = weather.description
        updateWeatherIcon(iconName: weather.iconName)
    }
    
    //If there was time this could be a utility function and would be stored in the object itself saving this unneeded call and could be stored.
    func updateWeatherIcon(iconName:String) {
        
        let session = URLSession.shared
        guard let urlRequest = ConnectionUtility.getWeatherIconRequest(iconName: iconName) else {
            return;
        }
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                return;
            }
            guard let responseData = data else {
                return;
            }
             DispatchQueue.main.async {
                let image = UIImage(data: responseData)
                self.weatherIconView.image = UIImage.init(data: responseData)
            }
        }
        task.resume()
    }
}
