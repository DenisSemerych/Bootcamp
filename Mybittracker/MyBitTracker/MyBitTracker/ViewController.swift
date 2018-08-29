//
//  ViewController.swift
//  MyBitTracker
//
//  Created by Denis Semerych on 09.05.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
   
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]

    let URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    var finalURL = ""
    
    var BTCPrice : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickCurrency.delegate = self
        pickCurrency.dataSource = self
        
    }

    @IBOutlet weak var bitPrice: UILabel!
    
    @IBOutlet weak var weekChanges: UILabel!
    
    @IBOutlet weak var dayChanges: UILabel!
    
    @IBOutlet weak var monthChanges: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    
   
    @IBOutlet weak var pickCurrency: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = URL + currencyArray[row]
        bitPrice.text = currencySymbols[row]
        updateInfo(finalURL)
    }
    func updateInfo (_ url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                self.updateLabels(JSON(response.result.value!))
            } else {
                
                print("Error: \(String(describing: response.result.error))")
                
            }
        }
    }
    
    func updateLabels (_ json: JSON) {
        
        if let value = json["ask"].double {
            BTCPrice = value
            bitPrice.text?.append(String(value))
        }
        if let value = json["changes"]["price"]["day"].double {
            dayChanges.text? = "Day changes: \(value)"
        }
        if let value = json["changes"]["price"]["month"].double {
            monthChanges.text? = "Month changes: \(value)"
        }
        if let value = json["changes"]["price"]["week"].double {
            weekChanges.text? = "Week changes: \(value)"
        }
    }
  
    @IBOutlet weak var enterNumber: UITextField!
    
    @IBAction func show(_ sender: UIButton) {
        if let a = BTCPrice {
            if let b = enterNumber.text {
                bitPrice.text = String(a * (Double(b) ?? 0))
            }
            enterNumber.resignFirstResponder()
        }
    }
    
}

