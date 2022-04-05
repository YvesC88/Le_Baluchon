//
//  Weather.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 16/03/2022.
//

import Foundation

struct Weather: Codable {
    struct DescriptionWeather: Codable {
        let id: Int
        let main, description, icon: String
    }
    struct Main: Codable {
        let temp, feelslike, tempmin, tempmax: Float
        let pressure, humidity: Int
        enum CodingKeys: String, CodingKey {
            case temp
            case feelslike = "feels_like"
            case tempmin = "temp_min"
            case tempmax = "temp_max"
            case pressure
            case humidity
        }
    }
    struct Sys: Codable {
        let type, id: Int
        let country: String
        let sunrise, sunset: Int
    }
    let weather: [DescriptionWeather]
    let main: Main
    let name: String!
    let sys: Sys
    let dt: Int!
}
