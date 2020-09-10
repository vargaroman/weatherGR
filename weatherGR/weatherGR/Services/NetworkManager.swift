//
//  NetworkManager.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

class NetworkManager {
    
        func getActualWeather(placeName: String, completionHandler: @escaping(WeatherDetail2)->Void) {
                
        guard let fullURL = URL(string: Constants.weatherAPILink+"q="+placeName+"&units=metric"+"&appid="+Constants.weatherAPIKey) else {return}
        
        let task = URLSession.shared.dataTask(with: fullURL, completionHandler: {(data,response,error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print(response)
                return
            }
            if let data = data,
                let weatherResult = try? JSONDecoder().decode(WeatherDetail2.self, from: data){
                print(weatherResult.main?.temp)
                    completionHandler(weatherResult)
            }
        })
        task.resume()
    }
    
    func getWeatherForNextDays(lon: String, lat: String, completionHandler: @escaping([Daily])->Void) {
                
            guard let fullURL = URL(string: Constants.oneCallAPILink+"lat="+lat+"&lon="+lon+"&exclude=hourly,current,minutely"+"&units=metric"+"&appid="+Constants.weatherAPIKey) else {return}
        
        let task = URLSession.shared.dataTask(with: fullURL, completionHandler: {(data,response,error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print(response)
                return
            }
            if let data = data {
                do {
                    let weatherResult = try JSONDecoder().decode(NextDaysWeather.self, from: data)
                    print(weatherResult)
                    if let dailyWeather = weatherResult.daily{
                        completionHandler(dailyWeather)
                    }
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    }
}
