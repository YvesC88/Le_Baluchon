//
//  LatestRates.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 15/03/2022.
//

import Foundation

struct LatestRates: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String:Float]
    
    var usdRate: Float? {
        return rates["USD"]
    }
}
