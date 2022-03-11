//
//  MainPresenter.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.
//

import UIKit

protocol MainPresenterDelegate: AnyObject {
 
    func displayItemList(viewModel: Main.Models.ViewModel)
    func displayError(message: String)
}

typealias MainPresenterInput = MaininteractorDelegate

class MainPresenter: MainPresenterInput {
 
    weak var viewController: MainPresenterDelegate?
  
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
    
}
