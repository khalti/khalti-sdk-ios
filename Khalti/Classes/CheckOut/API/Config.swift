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
    private var productUrl:String
    private var amount:Double
    private var additionalDate:Dictionary<String,Any>?
    private var delegate:CheckOutDelegate

    
    public init(publicKey:String,productId:String,productName:String, productUrl:String, amount:Double,delgate:CheckOutDelegate) {
        self.publicKey = publicKey
        self.productId = productId
        self.productName = productName
        self.productUrl = productUrl
        self.amount = amount
        self.delegate = delgate
    }
}
