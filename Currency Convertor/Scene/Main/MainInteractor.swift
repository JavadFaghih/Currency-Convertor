//
//  MainInteractor.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.
//

import UIKit
import RealmSwift

protocol MaininteractorDelegate {

    func presentError(message: String)
    func presentMyBalances(balance: Results<UserBalance>)
    func presentExchangeResult(_ result: Main.Models.ExchangeResponse)
}

protocol MainDataStore {
  //var name: String { get set }
}

typealias MainInteractorInput = MainViewControllerDelegate

class MainInteractor: NSObject, MainInteractorInput, MainDataStore {
    
    enum errors: Error {
        case noInternet
        case JPY
        case USD
        case EUR
        
        var description: String {
            switch self {
            case .noInternet:
                return "the Internet connection appears to be oflline"
            case .JPY:
                return "you do not have enough \(self) currency"
            case .USD:
                return "you do not have enough \(self) currency"
            case .EUR:
                return "you do not have enough \(self) currency"
            }
        }
        
    }
    

    var presenter: MaininteractorDelegate?
    private var worker: MainAPIWorker!
    private var isFirstRun: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isFirstRun")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isFirstRun")
            UserDefaults.standard.synchronize()
        }
    }
    private var group: DispatchGroup!
    private var exchange: Main.Models.ExchangeResponse!
    private var balance: [UserCurrencies]! //initial balances
    private var balances: Results<UserBalance>! //get value from database
    
  // MARK: Do something
    func viewDidload() {
         worker = MainAPIWorker()
        group = DispatchGroup()
        
        if isFirstRun {
            
            //if you need more currency just write it here to this balance
            balance = [UserCurrencies(symbol: CurrencySymbol.JPY.rawValue, amount: 0),
                       UserCurrencies(symbol: CurrencySymbol.EUR.rawValue, amount: 0),
                       UserCurrencies(symbol: CurrencySymbol.USD.rawValue, amount: 100)]
            
            DBManager.instance.save(object: UserBalance(id: 0, numberOfExchange: 0, balance: balance))
            isFirstRun = false
        }
        
      balances = DBManager.instance.read(object: UserBalance())
        
        presenter?.presentMyBalances(balance: balances)
        
    }
    
    func requestForExchange(fromAmount: String, fromCurrency: CurrencySymbol, toCurrency: CurrencySymbol) {
   
     //   let amount: String = String(fromAmount)
        
        group.enter()
        worker.exhangeRequest(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency) { [weak self] exchange, error in
            
            if let exchange = exchange {
                //save exchgange locally
                self?.exchange = exchange
                self?.group.leave()
                
            } else if error != nil {
                self?.presenter?.presentError(message: error!)
            } else {
                self?.presenter?.presentError(message: "sorry something went wrong...")
            }
        }
        
        group.notify(queue: .global()) { [unowned self]  in
        
            let transactionAmount = self.exchange.amount
            let destineyCurrency = self.exchange.currency
            
            
         //  DBManager.instance.save(object: self.balance)
            self.presenter?.presentExchangeResult(self.exchange)
        }
    }
    
    private func request(_ requsetModel: Main.Models.Request) throws {
        
        
        if currentReachabilityStatus == .notReachable {
            throw errors.noInternet
        } //else if balances
    }
}


