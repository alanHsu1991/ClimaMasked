//
//  WeatherData.swift
//  Clima
//
//  Created by Alan Hsu on 2020/11/30.
//

import Foundation

// Decoding for the data feeds from OpenWeather basing on their format

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
