//
//  MainPresenter.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.
//

import UIKit
import RealmSwift

protocol MainPresenterDelegate: AnyObject {
 
    func displayError(message: String)
    func displayBalanceItem(_ items: [Main.Models.ViewModel])
    func updateUI(recieveAmount: String)
    func displayTotalCommissions(_ comission: String)
}

typealias MainPresenterInput = MaininteractorDelegate

class MainPresenter: MainPresenterInput {
 
    weak var viewController: MainPresenterDelegate?
  
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
    
    func presentMyBalances(balance: UserBalance) {
        
            
            var balances: [Main.Models.ViewModel] = []
            
            for currency in balance.currencies {
                
                balances.append(Main.Models.ViewModel(amount: String(format: "%.2f", currency.Amount), symbol: currency.Symbol.rawValue))
            }
            
            viewController?.displayBalanceItem(balances)
    }
    
    func presentExchangeResult(_ result: Main.Models.ExchangeResponse) {
        let amount = "+ \(result.amount)"
        viewController?.updateUI(recieveAmount: amount)
    }
    
    func presentTotalCommision(comission: Double) {
        viewController?.displayTotalCommissions("You have already paid \(comission) commissions")
    }
}
