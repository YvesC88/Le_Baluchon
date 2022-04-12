//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 15/03/2022.
//

import Foundation
import UIKit

enum WeatherRoute: String {
    case weather
}

class WeatherService {
    static var shared = WeatherService()
    init() {}
    
    private static let baseUrl = URL(string: "http://api.openweathermap.org/data/2.5/")!
    private static let apiKeyParamKey: String = "appid"
    private static let langValue: String = "fr"
    private static let units: String = "units"
    private static let unitsValue: String = "metric"
    
    private var apiKey = ApiKeys()
    // dependacy removal for tests
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    private func getUrl(for route: WeatherRoute, city: String) -> URL? {
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        var urlString = "\(WeatherService.baseUrl)\(route.rawValue)"
        let cityMtp = "q=\(cityEncoded!)"
        let apiKeyParam = "\(WeatherService.apiKeyParamKey)=\(apiKey.keyWeather!)"
        let langParam = "lang=\(WeatherService.langValue)"
        let unitsParam = "\(WeatherService.units)=\(WeatherService.unitsValue)"
        urlString = "\(urlString)?\(cityMtp)&\(apiKeyParam)&\(langParam)&\(unitsParam)"
        return URL(string: urlString)
    }
    
    func getValue(city: String, callback: @escaping(Bool, Weather?) -> Void) {
        guard let url = getUrl(for: .weather, city: city) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(Weather.self, from: data)
                    callback(true, responseJSON)
                } catch {
                    print("\(error)")
                    callback(false, nil)
                }
            }
        }
        task.resume()
    }
}
