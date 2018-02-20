//
//  ViewController.swift
//  Khalti
//
//  Created by rjndra on 02/14/2018.
//  Copyright (c) 2018 rjndra. All rights reserved.
//

import UIKit
import Khalti

class ViewController: UIViewController {

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
        let additionalData:Dictionary<String,Any> = [
            "merchant_name" : "haha",
            "merchant_extra" : ["no":false,"yes":true]
         ]
        let TEST_CONFIG:Config = Config(publicKey: "test_public_key_03a427da14344b1eabe56ce1f8a0a024", amount: 2567, productId: "1234567890", productName: "Dragon_boss", productUrl: "http://gameofthrones.wikia.com/wiki/Dragons",additionalData: additionalData)
        Khalti.present(caller: self, with: TEST_CONFIG, delegate: self)
    }
}

extension ViewController: CheckOutDelegate {

    
    func onCheckOutSuccess(data: Dictionary<String, Any>) {
        print(data)
        print("Oh there is success message received")
    }
    
    func onCheckOutError(action: String, message: String) {
        print(action)
        print(message)
        print("Oh there occure error in payment")
    }
}

