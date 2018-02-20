//
//  KaltiApi.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import UIKit
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

public class KhaltiAPI {
    
    static let shared = KhaltiAPI()
    
    public var publicKey:String?
    
    internal let baseUrl: String = "http://192.168.1.211:8000"
    
    public func getBankList(onCompletion: @escaping ((Any)->()), onError: @escaping ((String)->())) {
        let url = baseUrl + "/api/bank/?has_ebanking= true"
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        headers["checkout-source"] = "iOS"
        headers["checkout-device-model"] = UIDevice.current.model
        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        headers["checkout-ios-version"] = UIDevice.current.systemVersion
        
        let request = Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headers)
        
        request.responseJSON { (responseJSON) in
            
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
    
    
    public func getPaymentInitiate(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
        
        let url = baseUrl + "/api/payment/initiate/"
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        headers["checkout-source"] = "iOS"
        headers["checkout-device-model"] = UIDevice.current.model
        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        headers["checkout-ios-version"] = UIDevice.current.systemVersion
        
        let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
        
        print(url)
        print(params)
        request.response { (response) in
        }
        request.responseJSON { (responseJSON) in
            
            switch responseJSON.result {
            case .success(let value):
                
                if let dict = value as? Dictionary<String, Any> {
                    onCompletion(dict)
                }
                break
            case .failure(let error):
                onError(error.localizedDescription)
                break
            }
        }
    }
    
    public func getPaymentConfirm(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
        
        let url = baseUrl + "/api/payment/confirm/"
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        headers["checkout-source"] = "iOS"
        headers["checkout-device-model"] = UIDevice.current.model
        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        headers["checkout-ios-version"] = UIDevice.current.systemVersion
        
        
        let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: headers)
        
        print(url)
        print(params)
        request.response { (response) in
        }
        request.responseJSON { (responseJSON) in
            
            switch responseJSON.result {
            case .success(let value):
                
                if let dict = value as? Dictionary<String, Any> {
                    onCompletion(dict)
                }
                break
            case .failure(let error):
                onError(error.localizedDescription)
                break
            }
        }
        
    }
    
}

