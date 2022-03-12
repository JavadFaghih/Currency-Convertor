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
    func presentMyBalances(balance: UserBalance)
    func presentExchangeResult(_ result: Main.Models.ExchangeResponse)
    func presentTotalCommision(comission: Double)
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
    
    private var currencies: [UserCurrencies]! //initials symbols
    private var balances: UserBalance! //get value from database
    
    //MARK: - ViewController delegate methods
    func viewDidload() {
        worker = MainAPIWorker()
    
        if isFirstRun {
            
            //if you need more currency just write it here to this balance and remove the app from simulator
            currencies = [UserCurrencies(symbol: CurrencySymbol.JPY, amount: 0),
                       UserCurrencies(symbol: CurrencySymbol.EUR, amount: 0),
                       UserCurrencies(symbol: CurrencySymbol.USD, amount: 1000) ]
            
            self.balances =  UserBalance(numberOfExchange: 0, balances: currencies)
            DBManager.instance.save(object: balances)
            isFirstRun = false
        }
        
        //get latest currencies from DB and present in collection view
        balances = UserBalance.getInfo()
        presenter?.presentMyBalances(balance: balances)
    }
    
    func requestForExchange(_ requestModel: Main.Models.Request) {
        
        do {
            try handleErrors(userRequest: requestModel , currenciesBalance: balances.currencies, numberOfExchange: balances.numberOfExchange)
            self.request(requestModel)
        } catch Errors.invalidInput {
            presenter?.presentError(message: Errors.invalidInput.description)
        } catch Errors.noInternet {
            presenter?.presentError(message: Errors.noInternet.description)
        } catch Errors.noEnoughCurrency {
            presenter?.presentError(message: Errors.noEnoughCurrency.description)
        } catch {
            presenter?.presentError(message: "sorry something went wrong")
        }
    }
    
    func getTotalComission() {
        
        presenter?.presentTotalCommision(comission: balances.totalComission)
    }
    
    
    //MARK: - Internal methods
    private func request(_ requsetModel: Main.Models.Request)  {
    
            worker.exhangeRequest(fromAmount: requsetModel.fromAmount, fromCurrency: requsetModel.fromCurrency, toCurrency: requsetModel.toCurrency) { [unowned self] exchange, error in
                
                if let exchange = exchange {
              
                    //update exchange localy
                    UserBalance.update(userBalance: balances,
                                       numberOfExchange: 1,
                                       fromAmount: requsetModel.fromAmount,
                                       fromcurrency: requsetModel.fromCurrency,
                                       toAmount: Double(exchange.amount) ?? 0,
                                       toCurrency: CurrencySymbol(rawValue: exchange.currency) ?? .USD)
                    
                    balances = UserBalance.getInfo()
                    presenter?.presentMyBalances(balance: balances)
                    
                    //present exchange request result to user
                    self.presenter?.presentExchangeResult(exchange)
                   
                } else if error != nil {
                    self.presenter?.presentError(message: error!)
                } else {
                    self.presenter?.presentError(message: "sorry something went wrong...")
                }
            }
        
    }
    
    private func handleErrors(userRequest: Main.Models.Request, currenciesBalance: List<UserCurrencies>, numberOfExchange: Int) throws {
        
        var fee: Double {
            get {
                userRequest.fromAmount * 0.07
            }
        }
        let requestSymbol: String = userRequest.fromCurrency.rawValue
        var requestAmount: Double {
            get {
              return  numberOfExchange <= 5 ? userRequest.fromAmount : (userRequest.fromAmount + fee)
            }
        }
        
        var balanceAmount: Double = 0
        
        if let balanceAmountIndex = currenciesBalance.firstIndex(where: {$0.Symbol.rawValue == requestSymbol}){
            
            balanceAmount = currenciesBalance[balanceAmountIndex].Amount
        }

        if currentReachabilityStatus == .notReachable {
            throw Errors.noInternet
        } else if requestAmount <= 0 {
            throw Errors.invalidInput
        } else if requestAmount > balanceAmount && numberOfExchange <= 5 {
            throw Errors.noEnoughCurrency
        } else if numberOfExchange > 5 && (requestAmount + fee) > balanceAmount {
            //no enough currency
            throw Errors.noEnoughCurrency
        }

    }
}
