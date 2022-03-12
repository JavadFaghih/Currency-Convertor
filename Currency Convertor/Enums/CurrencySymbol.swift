//
//  CurrencySymbol.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//

import Foundation
import RealmSwift

enum CurrencySymbol: String, CaseIterable, PersistableEnum {
    case EUR
    case USD
    case JPY
    case IR
}
