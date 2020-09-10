//
//  ViewController.swift
//  weatherGR
//
//  Created by Roman Varga on 09/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var currentWeather: WeatherDetail2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().getActualWeather(placeName: "london") { [weak self] (weather) in
            self?.currentWeather = weather
            DispatchQueue.main.async {
                self?.temperatureLabel.text = "\(weather.main?.temp ?? 0)"
                
            }
        }
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleWeatherCell")!
        return cell
    }

}

