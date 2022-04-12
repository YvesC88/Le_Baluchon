//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 15/03/2022.
//

import Foundation
import UIKit

enum TranslateRoute: String {
    case translate
}

class TranslateService {
    static var shared = TranslateService()
    init() {}
    
    private static let baseUrl = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    private static let letterToTranslate = "?q"
    private static var textToTranslate: String = " "
    private static let apiKeyParamKey: String = "key"
    private static var langageToTranslate = "fr"
    private static var targetLangage = "en"
    private static var formatText = "text"
    
    private var apiKey = ApiKeys()
    private var placeholder = ""
    // dependacy removal for tests
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    private var task: URLSessionDataTask?
    
    func changeTextUser(text: String) {
        TranslateService.textToTranslate = text
    }
    func changeLangage(source: String, target: String) {
        TranslateService.langageToTranslate = source
        TranslateService.targetLangage = target
    }
    
    private func getUrl(for route: TranslateRoute) -> URL? {
        let escapedString = TranslateService.textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        var urlString = "\(TranslateService.baseUrl)\(route.rawValue)"
        let textsToTranslate = "\(TranslateService.letterToTranslate)=\(escapedString!)"
        let apiKeyParam = "\(TranslateService.apiKeyParamKey)=\(apiKey.keyTranslate!)"
        let source = "source=\(TranslateService.langageToTranslate)"
        let target = "target=\(TranslateService.targetLangage)"
        let format = "format=\(TranslateService.formatText)"
        urlString = "\(TranslateService.baseUrl)\(textsToTranslate)&\(apiKeyParam)&\(source)&\(target)&\(format)"
        return URL(string: urlString)
    }
    
    func getValue(callback: @escaping (Bool, Translate?) -> Void) {
        guard let url = getUrl(for: .translate) else {
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
                    let responseJSON = try JSONDecoder().decode(Translate.self, from: data)
                    callback(true, responseJSON)
                } catch {
                    print("Erreur")
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }
}
