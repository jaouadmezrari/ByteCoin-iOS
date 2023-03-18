//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Abdeljaouad Mezrari on 30/02/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdate(coinManager: CoinManager, rate: RateModel)
    func didThrowError(coinManager: CoinManager, error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = ""
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    func fetchRate(currency: String){
        let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    self.delegate?.didThrowError(coinManager: self, error: error!)
                }
                if let safeData = data {
                    if let rate = self.parseJson(from: safeData){
                        self.delegate?.didUpdate(coinManager: self, rate: rate)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(from data: Data) -> RateModel?{
        var decoder = JSONDecoder()
        do {
            let decodedRate = try decoder.decode(RateData.self, from: data)
            let rateModel = RateModel(base_currency: decodedRate.asset_id_base, quote_currency: decodedRate.asset_id_quote, rate: decodedRate.rate)
            return rateModel
        } catch {
            self.delegate?.didThrowError(coinManager: self, error: error)
        }
        return nil
    }
    
}
