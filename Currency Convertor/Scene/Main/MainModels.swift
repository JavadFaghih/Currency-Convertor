//
//  MainModels.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.


import Foundation
import RealmSwift

enum Main {
    
    // MARK: Use cases
    enum Models {
        
        struct Request {
            let fromAmount: Double
            let fromCurrency: CurrencySymbol
            let toCurrency: CurrencySymbol
        }
        // MARK: - ExchangeResponse
        struct ExchangeResponse: Codable {
            let amount, currency: String
        }
        
        struct ViewModel {
            let amount: String
            let symbol: String
        }
    }
}



