//
//  ServerModels.swift
//  SimpleCurrencyConverter
//
//  Created by Ilya Makarevich on 2.10.23.
//

import Foundation

struct SymbolsResponse: Decodable {
    let success: Bool?
    let symbolsDict: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case symbolsDict = "symbols"
    }
}

struct Symbols: Codable {
    let symbols: [String: String]?
    let timestamp: TimeInterval
}


struct RatesResponse: Decodable {
    let success: Bool?
    let ratesDict: [String: Double]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case ratesDict = "rates"
    }
}

struct Rates: Codable {
    let base: String
    let rates: [String: Double]?
    let timestamp: TimeInterval
}
