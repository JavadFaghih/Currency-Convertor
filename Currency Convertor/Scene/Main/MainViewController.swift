//
//  MainViewController.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.

import UIKit

protocol MainViewControllerDelegate {

    func viewDidload()
    func requestForExchange(fromAmount: String, fromCurrency: CurrencySymbol, toCurrency: CurrencySymbol)
}

typealias MainViewControllerInput = MainPresenterDelegate

class MainViewController: UIViewController {
 
     //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sellAmountField: CustomTextfield!
    @IBOutlet weak var buyAmountField: CustomTextfield!
    @IBOutlet weak var submitBuuton: UIButton!
    @IBOutlet weak var sellCurrencySymbolField: CustomTextfield!
    @IBOutlet weak var receiveCurrencySymbolField: CustomTextfield!
    
     //MARK: - Vars
    var interactor: MainViewControllerDelegate?
    private var sellPickerView: UIPickerView!
    private var recievePickerView: UIPickerView!
    private var CurrenySymbolls: [String] = CurrencySymbol.allCases.map { $0.rawValue }
    private var balances: [Main.Models.ViewModel] = []
    
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
    viewController.interactor = interactor
    interactor.presenter = presenter
    presenter.viewController = viewController
   
  }
   
    // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
      let myBallanceCell = UINib(nibName: "MyBallanceCollectionViewCell", bundle: Bundle.main)
      
      collectionView.register(myBallanceCell, forCellWithReuseIdentifier: MyBallanceCollectionViewCell.reuseIdentifier)
      sellPickerView = UIPickerView()
      recievePickerView = UIPickerView()
      sellPickerView.delegate = self
      sellPickerView.dataSource = self
      recievePickerView.delegate = self
      recievePickerView.dataSource = self
      sellCurrencySymbolField.inputView = sellPickerView
      receiveCurrencySymbolField.inputView = recievePickerView
      
      interactor?.viewDidload()
      sellCurrencySymbolField.setRightImage(image: .pullDownImage)
      receiveCurrencySymbolField.setRightImage(image: .pullDownImage)
      sellAmountField.setLeftTitle(text: "Sell")
      buyAmountField.setLeftTitle(text: "Receive")
      hiddenKeyboardWhenTapRound()
      configNavBar()
      
      sellCurrencySymbolField.text = CurrenySymbolls[1]
      receiveCurrencySymbolField.text = CurrenySymbolls[0]
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        submitBuuton.layer.cornerRadius = submitBuuton.frame.size.height / 2
    }
    
     //MARK: - IBAction
    @IBAction func submitButtonPressed(_ sender: Any) {
      
        let amount = sellAmountField.text ?? ""
        var sellSymbol: CurrencySymbol {
            get {
                CurrencySymbol(rawValue: sellCurrencySymbolField.text ?? "") ?? .USD
            }
        }
        var recieveSymbol: CurrencySymbol {
            get {
                CurrencySymbol(rawValue: receiveCurrencySymbolField.text ?? "") ?? .EUR
            }
        }
        
        interactor?.requestForExchange(fromAmount: amount, fromCurrency: sellSymbol, toCurrency: recieveSymbol)
    }
    
     //MARK: - Methods
    private func alert(title: String = "Oops!", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default)
        alert.addAction(done)
        self.present(alert, animated: true)
    }
    
    private func configNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navBarTint
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    
}

     //MARK: - Presenter Delegate
extension MainViewController: MainViewControllerInput {
   
    func displayBalanceItem(_ items: [Main.Models.ViewModel]) {
        self.balances = items
        collectionView.reloadData()
    }
    
    func displayError(message: String) {
        alert(message: message)
    }
    
}

 //MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.balances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBallanceCollectionViewCell.reuseIdentifier, for: indexPath) as? MyBallanceCollectionViewCell else { return UICollectionViewCell()}
        
        cell.myBallance = balances[indexPath.row]
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

 //MARK: - PickerView Delegate
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        CurrenySymbolls.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        CurrenySymbolls[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.sellPickerView {
            sellCurrencySymbolField.text = CurrenySymbolls[row]
        } else {
            receiveCurrencySymbolField.text = CurrenySymbolls[row]
        }
    }
}
