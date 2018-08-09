//
//  ViewController.swift
//  Khalti
//
//  Created by rjndra on 02/14/2018.
//  Copyright (c) 2018 rjndra. All rights reserved.
//

import UIKit
import Khalti

class ViewController: UIViewController, KhaltiPayDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func payNow(_ sender: UIButton) {
        let extra:[String : Any] =  ["no":false,"yes":true,"int" : 0, "float":12.23]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: extra, options: JSONSerialization.WritingOptions())
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        
        let additionalData:Dictionary<String,String> = [
            "merchant_name" : "haha",
            "merchant_extra" : jsonString
         ]
        
        Khalti.shared.appUrlScheme = khaltiUrlScheme
        let khaltiMerchantKey = "test_public_key_1d57e4d159794c6790a62f8953124053"
        
        let TEST_CONFIG:Config = Config(publicKey: khaltiMerchantKey, amount: 1000, productId: "1234567890", productName: "Dragon_boss", productUrl: "http://gameofthrones.wikia.com/wiki/Dragons",additionalData: additionalData, ebankingPayment: false)
        
        Khalti.shared.debugLog = true
        Khalti.present(caller: self, with: TEST_CONFIG, delegate: self)
    }
    
    func onCheckOutSuccess(data: Dictionary<String, Any>) {
        print(data)
        print("Oh there is success message received")
    }
    
    func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        print(action)
        print(message)
        if let value = data {
            print(value)
        }
        print("Oh there occure error in payment")
    }
    
}

