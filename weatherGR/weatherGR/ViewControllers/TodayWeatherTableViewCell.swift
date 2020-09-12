//
//  TodayWeatherTableViewCell.swift
//  weatherGR
//
//  Created by Roman Varga on 11/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

protocol GetLocationProtocolDelegate {
    func getMyLocation()
}

class TodayWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    var getLocationDelegate: GetLocationProtocolDelegate?
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Function set app background
    /// - Parameter weather: weather description string
    func setBackgroundImage(weather: String){
        print(weather)
        switch weather {
        case "Drizzle":
            self.weatherImageView.image = UIImage(named: "Drizzle")
        case "Thunderstorm":
            self.weatherImageView.image = UIImage(named: "Thundering")
        case "Rain":
            self.weatherImageView.image = UIImage(named: "Rainy")
        case "Snow":
            self.weatherImageView.image = UIImage(named: "Snowing")
        case "Clouds":
            self.weatherImageView.image = UIImage(named: "Cloudy")
        case "Clear":
            self.weatherImageView.image = UIImage(named: "ClearSky")
        default:
            print("error")
        }
    }
    
    @IBAction func currentLocationAction(_ sender: Any) {
        getLocationDelegate?.getMyLocation()
    }
    
}
