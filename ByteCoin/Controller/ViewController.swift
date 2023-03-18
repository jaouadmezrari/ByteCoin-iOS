//
//  ViewController.swift
//  ByteCoin
//
//  Created by Abdeljaouad Mezrari on 30/02/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var coinPicker: UIPickerView!
    var coinManager: CoinManager = CoinManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indexUsd = coinManager.currencyArray.lastIndex(of: "USD")!
        coinPicker.delegate = self
        coinPicker.dataSource = self
        coinPicker.selectRow(coinManager.currencyArray.lastIndex(of: "USD")!,inComponent: 0, animated: true)
        coinManager.delegate = self
        
        coinPicker.delegate?.pickerView?(coinPicker, didSelectRow: indexUsd, inComponent: 0)

    }

}


//MARK: - UIpickerDelegation - DataSource
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow: Int, inComponent: Int){
        let selectedCurrency = coinManager.currencyArray[didSelectRow]
        currencyLabel.text = selectedCurrency
        coinManager.fetchRate(currency: selectedCurrency)
    }
}


//MARK: - CoinManagerDelegation
extension ViewController: CoinManagerDelegate{
    func didThrowError(coinManager: CoinManager, error: Error){
        print(error)
    }
    
    func didUpdate(coinManager: CoinManager, rate: RateModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.3f", rate.rate)
        }
    }
}
