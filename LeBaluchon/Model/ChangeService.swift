//
//  ChangeService.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 15/03/2022.
//

import Foundation
import UIKit

enum ChangeRoute: String {
    case latest
}

protocol ChangeServiceDelegage: AnyObject {
    func textUser(value: String)
}

class ChangeService {
    static var shared = ChangeService()
    init() {}
    
    private var task: URLSessionDataTask?
    weak var delegate: ChangeServiceDelegage?
    private var apiKey = ApiKeys()
    
    private var storedDollarRate: Float?
    private var storedDateRate = userDefaultsDateKey
    // dependacy removal for tests
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    private static let baseUrl = URL(string: "http://data.fixer.io/api/")!
    private static let apiKeyParamKey: String = "access_key"
    private static let userDefaultsRateKey = "usdRateValue"
    private static let userDefaultsDateKey = "usdRateDate"
    
    private func getUrl(for route: ChangeRoute) -> URL? {
        var urlString = "\(ChangeService.baseUrl)\(route.rawValue)"
        let apiKeyParam = "\(ChangeService.apiKeyParamKey)=\(apiKey.keyChange!)"
        urlString = "\(urlString)?\(apiKeyParam)"
        return URL(string: urlString)
    }
    
    func getValue(callback: @escaping (Bool, LatestRates?) -> Void) {
        guard let url = getUrl(for: .latest) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
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
                    let responseJSON = try JSONDecoder().decode(LatestRates.self, from: data)
                    callback(true, responseJSON)
                } catch {
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }
    // function that makes a call api every 24 hours
    func fetchCurrentRate(callback: @escaping (Float?, Date) -> Void) {
        let savedRateTimestamp = UserDefaults.standard.double(forKey: ChangeService.userDefaultsDateKey)
        let currentTimestamp = Date().timeIntervalSince1970
        let diff = currentTimestamp - savedRateTimestamp
        guard savedRateTimestamp == 0 || diff >= 24.0*60.0*60.0 else {
            let rate = UserDefaults.standard.float(forKey: ChangeService.userDefaultsRateKey)
            self.storedDollarRate = rate
            callback(rate, Date(timeIntervalSince1970: savedRateTimestamp))
            return
        }
        getValue { success, rate in
            self.storedDollarRate = rate?.usdRate
            self.saveCurrentRate()
            callback(rate?.usdRate, Date())
        }
    }
    // function that calculates user value by locally stored dollar rate
    func calculation(value: Float) -> Float? {
        guard let storedDollarRate = storedDollarRate else {
            return nil
        }
        return value * storedDollarRate
    }
    // saves locally the date and stored dollar rate during the last api call
    func saveCurrentRate() {
        guard let storedDollarRate = storedDollarRate else {
            return
        }
        UserDefaults.standard.set(storedDollarRate, forKey: ChangeService.userDefaultsRateKey)
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: ChangeService.userDefaultsDateKey)
    }
}
