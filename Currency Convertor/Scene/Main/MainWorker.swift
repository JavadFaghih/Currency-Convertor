//
//  MainWorker.swift
//  Currency Convertor
//
//  Created by Javad on 12/19/1400 AP.
//  Copyright (c) 1400 AP Javad Faghih. All rights reserved.
//

import Foundation
import Alamofire

class MainAPIWorker {
  
    func exhangeRequest(_ requestModel: Main.Models.Request, complations: @escaping(_ response: Main.Models.ExchangeResponse?,_ errors: String?) -> Void) {
        
        AF.request("\(API_URL.exchange.rawValue)\(requestModel.fromAmount)-\(requestModel.fromCurrency.rawValue)/\(requestModel.toCurrency.rawValue)/latest").responseData { response in
          
            switch response.result {
                
            case .success(let jsonData):
                let exchange = try? JSONDecoder().decode(Main.Models.ExchangeResponse.self, from: jsonData)
                complations(exchange, nil)
            case .failure(let error):
                complations(nil, error.localizedDescription)
            }
        }
    }
}
