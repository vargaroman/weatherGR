////
////  Weather.swift
////  weatherGR
////
////  Created by Roman Varga on 10/09/2020.
////  Copyright © 2020 Roman Varga. All rights reserved.
////
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let weatherDetail = try? newJSONDecoder().decode(WeatherDetail.self, from: jsonData)
//
//import Foundation
//
//// MARK: - WeatherDetail
//class WeatherDetail: Codable {
//    let coord: Coord
//    let weather: [Weather]
//    let base: String
//    let main: Main
//    let visibility: Int
//    let wind: Wind
//    let clouds: Clouds
//    let dt: Int
//    let sys: Sys
//    let id: Int
//    let name: String
//    let cod: Int
//
//    init(coord: Coord, weather: [Weather], base: String, main: Main, visibility: Int, wind: Wind, clouds: Clouds, dt: Int, sys: Sys, id: Int, name: String, cod: Int) {
//        self.coord = coord
//        self.weather = weather
//        self.base = base
//        self.main = main
//        self.visibility = visibility
//        self.wind = wind
//        self.clouds = clouds
//        self.dt = dt
//        self.sys = sys
//        self.id = id
//        self.name = name
//        self.cod = cod
//    }
//}
//
//// MARK: - Clouds
//class Clouds: Codable {
//    let all: Int
//
//    init(all: Int) {
//        self.all = all
//    }
//}
//
//// MARK: - Coord
//class Coord: Codable {
//    let lon, lat: Double
//
//    init(lon: Double, lat: Double) {
//        self.lon = lon
//        self.lat = lat
//    }
//}
//
//// MARK: - Main
//class Main: Codable {
//    let temp: Double
//    let pressure, humidity: Int
//    let tempMin, tempMax: Double
//
//    enum CodingKeys: String, CodingKey {
//        case temp, pressure, humidity
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//    }
//
//    init(temp: Double, pressure: Int, humidity: Int, tempMin: Double, tempMax: Double) {
//        self.temp = temp
//        self.pressure = pressure
//        self.humidity = humidity
//        self.tempMin = tempMin
//        self.tempMax = tempMax
//    }
//}
//
//// MARK: - Sys
//class Sys: Codable {
//    let type, id: Int
//    let message: Double
//    let country: String
//    let sunrise, sunset: Int
//
//    init(type: Int, id: Int, message: Double, country: String, sunrise: Int, sunset: Int) {
//        self.type = type
//        self.id = id
//        self.message = message
//        self.country = country
//        self.sunrise = sunrise
//        self.sunset = sunset
//    }
//}
//
//// MARK: - Weather
//class Weather: Codable {
//    let id: Int
//    let main, weatherDescription, icon: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, main
//        case weatherDescription = "description"
//        case icon
//    }
//
//    init(id: Int, main: String, weatherDescription: String, icon: String) {
//        self.id = id
//        self.main = main
//        self.weatherDescription = weatherDescription
//        self.icon = icon
//    }
//}
//
//// MARK: - Wind
//class Wind: Codable {
//    let speed: Double
//    let deg: Int
//
//    init(speed: Double, deg: Int) {
//        self.speed = speed
//        self.deg = deg
//    }
//}
