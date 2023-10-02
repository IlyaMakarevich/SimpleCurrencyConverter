//
//  APIService.swift
//  SimpleCurrencyConverter
//
//  Created by Ilya Makarevich on 2.10.23.
//

import Foundation

final class APIService {
    private let apiKey = "94e6149308804f0d640e4464e8a550a2"
    private let baseURL = "http://api.exchangeratesapi.io/v1"
    
    func loadSymbols(callback: @escaping (Bool, [String: String], TimeInterval) -> Void) {
        let urlSession = URLSession.shared
        let url = URL(string: "\(baseURL)/symbols?access_key=\(apiKey)")
        
        urlSession.dataTask(with: url!) { data, response, error in
            if let error = error {
                print(error)
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let json = try? JSONDecoder().decode(SymbolsResponse.self, from: data)
                if let s = json?.symbolsDict {
                    callback(true, s, Date().timeIntervalSince1970)
                } else {
                    callback(false, [:], 0.0)
                }
            } else {
                callback(false, [:], 0.0)
            }
        }.resume()
    }
    
    func loadRates(base: String,
                   symbols: String,
                   callback: @escaping (Bool, [String: Double], TimeInterval) -> Void) {
        let urlSession = URLSession.shared
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let resultString = dateFormatter.string(from: Date())
        
        let url = URL(string: "\(baseURL)/\(resultString)?access_key=\(apiKey)&symbols=\(symbols)")
        
        urlSession.dataTask(with: url!) { data, response, error in
            if let error = error {
                print(error)
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let json = try? JSONDecoder().decode(RatesResponse.self, from: data)
                if let s = json?.ratesDict {
                    callback(true, s, Date().timeIntervalSince1970)
                } else {
                    callback(false, [:], 0.0)
                }
            } else {
                callback(false, [:], 0.0)
            }
        }.resume()
    }
}
