//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Yves Charpentier on 13/04/2022.
//

import Foundation

class FakeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class ModelError: Error{}
    static let weatherError = ModelError()
    static let latestRatesError = ModelError()
    static let translateError = ModelError()
    
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    
    static var translateCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let translateIncorrectData = "erreur".data(using: .utf8)!
    
    static var changeCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Change", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let changeIncorrectData = "erreur".data(using: .utf8)!
}
