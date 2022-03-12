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


class UserBalance: Object {
    
    @Persisted var id: String
    @Persisted var numberOfExchange: Int = 0
    @Persisted var totalComission: Double = 0
    @Persisted var currencies: List<UserCurrencies>
    
    convenience init(numberOfExchange: Int, commision: Double = 0, balances: [UserCurrencies]) {
        self.init()
        self.id = UUID().uuidString
        self.numberOfExchange = numberOfExchange
        self.currencies.append(objectsIn: balances)
        self.totalComission = commision
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    static func getInfo() -> UserBalance? {
        
        do {
            let realm = try Realm()
            return realm.objects(UserBalance.self).last
        } catch {
            return nil
        }
    }
    
    static func update(userBalance: UserBalance, numberOfexchange: Int, balance: UserCurrencies) {
        
        let updatedBalance = UserBalance()
        updatedBalance.numberOfExchange = userBalance.numberOfExchange
        updatedBalance.numberOfExchange += numberOfexchange
        updatedBalance.id = userBalance.id
        updatedBalance.currencies.append(balance)
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(updatedBalance, update: .modified)
            }
        } catch {
            print("error happend while updating User Balance")
        }
    }
}

class UserCurrencies: Object {
    
    @Persisted var id: String
    @Persisted var Symbol: CurrencySymbol
    @Persisted var Amount: Double
    
    @Persisted(originProperty: "currencies") var assignee: LinkingObjects<UserBalance>
    
    convenience init(symbol: CurrencySymbol, amount: Double) {
        self.init()
        self.id = UUID().uuidString
        self.Symbol = symbol
        self.Amount = amount
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}
