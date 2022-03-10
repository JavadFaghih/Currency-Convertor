//
//  MainViewController.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol MainViewControllerDelegate {

    func viewDidload()
}

typealias MainViewControllerInput = MainPresenterDelegate

class MainViewController: UIViewController {
 
    
    @IBOutlet weak var submitBuuton: UIButton!
    
    var interactor: MainViewControllerDelegate?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?

  // MARK: Object lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
 
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  private func setup() {
  
    let viewController = self
    let interactor = MainInteractor()
    let presenter = MainPresenter()
    let router = MainRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
      if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
   
    // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
      interactor?.viewDidload()
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        submitBuuton.layer.cornerRadius = submitBuuton.frame.size.height / 2
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
    }
    
    
}

     //MARK: - Presenter Delegate
extension MainViewController: MainViewControllerInput {
   
    func displayItemList(viewModel: Main.Models.ViewModel) {
      //nameTextField.text = viewModel.name
        
    }
}

