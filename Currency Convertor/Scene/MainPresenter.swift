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
}

typealias MainPresenterInput = MaininteractorDelegate

class MainPresenter: MainPresenterInput {
 
    weak var viewController: MainPresenterDelegate?
  
  // MARK: Do something
  func presentSomething(response: Main.Models.Response) {
  
      let viewModel = Main.Models.ViewModel()
    viewController?.displayItemList(viewModel: viewModel)
  }
}
