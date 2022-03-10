//
//  MainRouter.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol MainRoutingLogic {

    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MainDataPassing {

    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {

    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    private  let storyboard = UIStoryboard(name: "Main", bundle: nil)

    
  // MARK: Routing
  //func routeToSomewhere(segue: UIStoryboardSegue?) {
  
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }


  // MARK: Navigation
  //func navigateToSomewhere(source: MainViewController, destination: SomewhereViewController) {
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
    
  //func passDataToSomewhere(source: MainDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
