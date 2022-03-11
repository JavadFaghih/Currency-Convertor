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
            let fromAmount: String
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


class UserBalance: Object {
    
    @Persisted var id = 0
    @Persisted var numberOfExchange: Int = 0
    @Persisted var currencies: List<UserCurrencies>
    
    convenience init(id: Int, numberOfExchange: Int, balance: [UserCurrencies]) {
        self.init()
        self.id = id
        self.numberOfExchange = numberOfExchange
        self.currencies.append(objectsIn: balance)
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}

class UserCurrencies: Object {
    @Persisted var Symbol: String
    @Persisted var Amount: Double
    
    @Persisted(originProperty: "currencies") var assignee: LinkingObjects<UserBalance>
    
    convenience init(symbol: String, amount: Double) {
        self.init()
        self.Symbol = symbol
        self.Amount = amount
    }
    
}
