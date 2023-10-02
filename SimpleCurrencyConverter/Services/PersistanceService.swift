//
//  PersistanceService.swift
//  SimpleCurrencyConverter
//
//  Created by Ilya Makarevich on 2.10.23.
//

import Foundation

struct CurrencyItem: Codable, Equatable {
    let code: String
    let value: String
}

final class PersistanceService {
    private let defaults = UserDefaults.standard
    
    func saveSymbols(from: CurrencyItem, to: CurrencyItem) {
        var saved = getSymbols()
        if !saved.contains(where: { $0 == from }) {
            saved.append(from)
        }
        if !saved.contains(where: { $0 == to }) {
            saved.append(to)
        }
        
        let data = saved.map { try? JSONEncoder().encode($0) }
        defaults.set(data, forKey: "myFavorites")
    }
    
    
    func removeSymbols(from: CurrencyItem, to: CurrencyItem) {
        var saved = getSymbols()
        saved.removeAll(where: {$0.code == from.code})
        saved.removeAll(where: {$0.code == to.code})
        let data = saved.map { try? JSONEncoder().encode($0) }
        defaults.set(data, forKey: "myFavorites")
    }
    
    func getSymbols() -> [CurrencyItem] {
        guard let encodedData = defaults.array(forKey: "myFavorites") as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(CurrencyItem.self, from: $0) }
    }
    
}
