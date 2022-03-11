//
//  MainInteractor.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.
//

import UIKit

protocol MaininteractorDelegate {

    func presentError(message: String)
}

protocol MainDataStore {
  //var name: String { get set }
}

typealias MainInteractorInput = MainViewControllerDelegate

class MainInteractor: MainInteractorInput, MainDataStore {
    
    enum erros: Error {
        case noInternet
        case n
    }
    

    var presenter: MaininteractorDelegate?
    private var worker: MainAPIWorker!
  
  
  // MARK: Do something
    func viewDidload() {
         worker = MainAPIWorker()
    }
    
    func requestForExchange(fromAmount: String, fromCurrency: CurrencySymbol, toCurrency: CurrencySymbol) {
   
        let amount: String = String(fromAmount)
        
        worker.exhangeRequest(fromAmount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency) { [weak self] exchange, error in
            
            if let exchange = exchange {
                //persist exchgange locally
                
            } else if error != nil {
                self?.presenter?.presentError(message: error!)
            } else {
                self?.presenter?.presentError(message: "sorry something went wrong")
            }
        }
    }
    
    private func request() throws {
        
//        if {
//           
//            
//        } else {
//            
//            
//        }
    }
}
