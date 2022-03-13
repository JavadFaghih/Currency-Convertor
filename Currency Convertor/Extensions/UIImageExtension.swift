//
//  UIImageExtension.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//

import UIKit

extension UIImage {
    
    open class var pullDownImage: UIImage {
        get {
            UIImage(named: "pullDown") ?? UIImage()
        }
    }
    
    open class var recieveImage: UIImage {
        get {
            UIImage(named: "recieveImage") ?? UIImage()
        }
    }
    
    open class var sellImage: UIImage {
        get {
            UIImage(named: "sellImage") ?? UIImage()
        }
    }
    
}
