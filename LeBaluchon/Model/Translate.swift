//
//  Translate.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 21/03/2022.
//

import Foundation

struct Translate: Codable {
    struct Data: Codable {
        let translations: [Translation]
        struct Translation: Codable {
            let translatedText: String
        }
    }
    let data: Data
}
