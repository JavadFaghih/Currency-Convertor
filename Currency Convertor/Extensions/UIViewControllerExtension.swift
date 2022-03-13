//
//  UIViewControllerExtension.swift
//  Currency Convertor
//
//  Created by Javad on 12/20/1400 AP.
//

import UIKit

extension UIViewController {
    
    
    func hiddenKeyboardWhenTapRound() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
