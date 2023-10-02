//
//  APIService.swift
//  SimpleCurrencyConverter
//
//  Created by Ilya Makarevich on 2.10.23.
//

import Foundation

final class APIService {
    private let apiKey = "526583d97e8f42e96dfb816654c2cc06"
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
                if let symbolsDict = json?.symbolsDict {
                    callback(true, symbolsDict, Date().timeIntervalSince1970)
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
        let url = URL(string: "\(baseURL)/latest?access_key=\(apiKey)&base=\(base)&symbols=\(symbols)")
        
        urlSession.dataTask(with: url!) { data, response, error in
            if let error = error {
                print(error)
            }
            
            if let data = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                let json = try? JSONDecoder().decode(RatesResponse.self, from: data)
                if let ratesDict = json?.ratesDict {
                    callback(true, ratesDict, Date().timeIntervalSince1970)
                } else {
                    callback(false, [:], 0.0)
                }
            } else {
                callback(false, [:], 0.0)
            }
        }.resume()
    }
}
