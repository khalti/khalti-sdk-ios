//
//  Config.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation
import Alamofire

public struct Config {
    private var publicKey:String
    private var productId:String
    private var productName:String
    private var productUrl:String?
    private var amount:Int
    private var additionalData:Dictionary<String,String>?

    public init(publicKey:String,  amount:Int, productId:String,productName:String, productUrl:String? = nil, additionalData:Dictionary<String,String>? = nil) {
        self.publicKey = publicKey
        self.productId = productId
        self.productName = productName
        self.productUrl = productUrl
        self.amount = amount
        self.additionalData = additionalData
    }
    
    func getPublicKey() -> String {
        return self.publicKey
    }
    
    func getAmount() -> Int {
        return self.amount
    }
    
    func getProductId() -> String {
        return self.productId
    }
    
    func getProductName() -> String {
        return self.productName
    }
    
    func getProductUrl() -> String? {
        return self.productUrl
    }
    
    func getAdditionalData() -> Dictionary<String,String>? {
        if let data = self.additionalData {
            return data
        }
        return nil
    }
}
