//
//  Errors.swift
//  Currency Convertor
//
//  Created by Javad on 12/20/1400 AP.
//

import Foundation
import SwiftUI

enum Errors: Error {
    
    case noInternet
    case invalidInput
    case noEnoughCurrency
    
    var description: String {
      
        switch self {
        case .noInternet:
            return "the Internet connection appears to be oflline"
        case .invalidInput:
            return "sorry your request is invalid"
        case .noEnoughCurrency:
            return "you do not have enough currency"
            
        }
    }
}
