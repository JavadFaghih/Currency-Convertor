//
//  MainInteractor.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.
//

import UIKit

protocol MaininteractorDelegate {

    func presentSomething(response: Main.Models.Response)
}

protocol MainDataStore {
  //var name: String { get set }
}

typealias MainInteractorInput = MainViewControllerDelegate

class MainInteractor: MainInteractorInput, MainDataStore {

    var presenter: MaininteractorDelegate?
    var worker: MainWorker?
  //var name: String = ""
  
  // MARK: Do something
    func viewDidload() {
        
    }
}
