//
//  UIColorExtension.swift
//  Currency Convertor
//
//  Created by Javad on 12/20/1400 AP.
//

import UIKit

extension UIColor {
    
    open class var navBarTint: UIColor {
        get {
            UIColor(named: "navBarTint") ?? .white
        }
    }
}
