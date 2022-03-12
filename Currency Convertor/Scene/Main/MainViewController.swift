//
//  MainViewController.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.

import UIKit

protocol MainViewControllerDelegate {
    
    func viewDidload()
    func requestForExchange(_ requestModel: Main.Models.Request)
    func getTotalComission()
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
        
        configCollectionView()
        configPickerView()
        interactor?.viewDidload()
        hiddenKeyboardWhenTapRound()
        configNavBar()
        prepareTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        submitBuuton.layer.cornerRadius = submitBuuton.frame.size.height / 2
    }
    
    //MARK: - IBAction
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        var amount: Double {
            get {
               Double(sellAmountField.text ?? "") ?? 0
            }
        }
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
        
        interactor?.requestForExchange(Main.Models.Request(fromAmount: amount,
                                                           fromCurrency: sellSymbol,
                                                           toCurrency: recieveSymbol))
        submitBuuton.isEnabled = false
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        
        interactor?.getTotalComission()
    }
    
    //MARK: - Methods
    private func configPickerView() {
        sellPickerView = UIPickerView()
        recievePickerView = UIPickerView()
        sellPickerView.delegate = self
        sellPickerView.dataSource = self
        recievePickerView.delegate = self
        recievePickerView.dataSource = self
        sellCurrencySymbolField.inputView = sellPickerView
        receiveCurrencySymbolField.inputView = recievePickerView
    }
    private func prepareTextFields() {
        
        sellCurrencySymbolField.setRightImage(image: .pullDownImage)
        receiveCurrencySymbolField.setRightImage(image: .pullDownImage)
        sellAmountField.setLeftTitle(text: "Sell")
        buyAmountField.setLeftTitle(text: "Receive")
        sellCurrencySymbolField.text = CurrenySymbolls[1]
        receiveCurrencySymbolField.text = CurrenySymbolls[0]
        sellAmountField.delegate = self
    }
    
    private func configCollectionView() {
        let myBallanceCell = UINib(nibName: "MyBallanceCollectionViewCell", bundle: Bundle.main)
        collectionView.register(myBallanceCell, forCellWithReuseIdentifier: MyBallanceCollectionViewCell.reuseIdentifier)
        
    }
    
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
        DispatchQueue.main.async {
            self.buyAmountField.text = ""
            self.submitBuuton.isEnabled = true
        }
    }
    
    func updateUI(recieveAmount: String, dialogMessage: String) {
     
        DispatchQueue.main.async {
            self.buyAmountField.text = recieveAmount
            self.alert(title: "Currency converted", message: dialogMessage)
            self.submitBuuton.isEnabled = true
        }
    }
    
    func displayTotalCommissions(_ comission: String) {
        self.alert(message: comission)
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

//for prevent use two dote in amount field
extension MainViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let dotsCount = textField.text!.components(separatedBy: (".")).count - 1
        if dotsCount > 0 && (string == "." || string == ",") {
            return false
        }
        
        if string == "," {
            textField.text! += "."
            return false
        }
        
        return true
    }
}

