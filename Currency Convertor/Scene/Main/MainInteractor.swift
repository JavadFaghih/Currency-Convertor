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
    
    //MARK: - Vars
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
    private var currencies: [UserCurrencies]! //initial balances
    private var userBalane: UserBalance!
    private var balances: Results<UserBalance>! //get value from database
    private var requestModel: Main.Models.Request!
    
    //MARK: - ViewController delegate methods
    func viewDidload() {
        worker = MainAPIWorker()
        group = DispatchGroup()
        
        if isFirstRun {
            
            //if you need more currency just write it here to this balance and remove the app from simulator
            currencies = [UserCurrencies(symbol: CurrencySymbol.JPY.rawValue, amount: 0),
                       UserCurrencies(symbol: CurrencySymbol.EUR.rawValue, amount: 0),
                       UserCurrencies(symbol: CurrencySymbol.USD.rawValue, amount: 100) ]
            
            self.userBalane =  UserBalance(id: 0, numberOfExchange: 0, balance: currencies)
            
            DBManager.instance.save(object: userBalane)
            isFirstRun = false
        }
        
        balances = DBManager.instance.read(object: UserBalance())
        presenter?.presentMyBalances(balance: balances)
    }
    
    func requestForExchange(_ requestModel: Main.Models.Request) {
        
        self.requestModel = requestModel
        
        do {
            try request(requestModel)
          //  group.enter()
        } catch Errors.invalidInput {
            presenter?.presentError(message: Errors.invalidInput.description)
        } catch Errors.noInternet {
            presenter?.presentError(message: Errors.noInternet.description)
        } catch Errors.USD {
            presenter?.presentError(message: Errors.USD.description)
        } catch Errors.EUR {
            presenter?.presentError(message: Errors.EUR.description)
        } catch Errors.JPY {
            presenter?.presentError(message: Errors.JPY.description)
        } catch {
            presenter?.presentError(message: "sorry something went wrong")
        }
        
        group.notify(queue: .global(qos: .background)) { [unowned self]  in
            
        //    let transactionAmount = self.exchange.amount
         //   let destineyCurrency = self.exchange.currency
            
           
        }
    }
    
    
    //MARK: - Internal methods
    private func request(_ requsetModel: Main.Models.Request) throws {
        
        var numberOfExchange: Int = balances.last?.numberOfExchange ?? 0
        var currenciesBalance: List<UserCurrencies>? = balances.last?.currencies
        
       // currenciesBalance?.last.
        
        if currentReachabilityStatus == .notReachable {
            throw Errors.noInternet
        } //else if requestModel.fromAmount >
        
        else {
            
            worker.exhangeRequest(fromAmount: requestModel.fromAmount, fromCurrency: requestModel.fromCurrency, toCurrency: requestModel.toCurrency) { [weak self] exchange, error in
                
                if let exchange = exchange {
                  
                    //save exchgange locally
                    self?.exchange = exchange
                    self?.balances?.last?.numberOfExchange += 1
              
                    //save exchange localy
                    
                    DBManager.instance.save(object: self?.balances?.last ?? UserBalance())
                    
                    //present exchange request result to user
                    self?.presenter?.presentExchangeResult(exchange)
                    
                    
                    //  self?.group.leave()
                    
                } else if error != nil {
                    
                    self?.presenter?.presentError(message: error!)

                } else {
                    
                    self?.presenter?.presentError(message: "sorry something went wrong...")
                }
            }
            
        }
    }
}


