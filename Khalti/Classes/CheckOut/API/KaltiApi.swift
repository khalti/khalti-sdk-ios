//
//  KaltiApi.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation
import Alamofire

enum ErrorMessage:String {
    case server = "Kahlti Server Error"
    case noAccess = "Access is denied"
    case badRequest = "Invalid data request"
    case tryAgain = "Something went wrong.Please try again later"
    case timeOut = "Request time out."
    case noConnection = "No internet Connection."
}

public class KhaltiConfig {
    
    static let shared = KhaltiConfig()
    
    public var publicKey:String?
    
    internal let baseUrl: String = "a.khalti.com"
    
    public func getBankList(onCompletion: @escaping ((Any)->()), onError: @escaping ((String)->())) {
        let url = baseUrl + "/api/bank/?has_ebanking= true"
        Alamofire.request(url).validate().responseJSON { (responseJSON) in
            
            switch responseJSON.result {
            case .success(let value):
                onCompletion(value)
                break
            case .failure(let error):
                onError(error.localizedDescription)
                break
            }
        }
    }
    
    
    public func getPaymentInitiate(onCompletion: @escaping ((Any)->()), onError: @escaping ((String)->())) {
        let url = baseUrl + "api/payment/initiate/"
        let request = Alamofire.request(url)
        
        request.validate().responseJSON { (responseJSON) in
            
            switch responseJSON.result {
            case .success(let value):
                onCompletion(value)
                break
            case .failure(let error):
                onError(error.localizedDescription)
                break
            }
        }
    }
}

