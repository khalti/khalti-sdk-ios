//
//  KaltiApi.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import UIKit
import Foundation
import Alamofire

enum KhaltiAPIUrl: String {
    case bankList = "http://192.168.1.211:8000/api/bank/?has_ebanking=true&page_size=200"
    case paymentInitiate = "http://192.168.1.211:8000/api/payment/initiate/"
    case paymentConfirm = "http://192.168.1.211:8000/api/payment/confirm/"
}

enum ErrorMessage:String {
    case server = "Kahlti Server Error"
    case noAccess = "Access is denied"
    case badRequest = "Invalid data request"
    case tryAgain = "Something went wrong.Please try again later"
    case timeOut = "Request time out."
    case noConnection = "No internet Connection."
}

class KhaltiAPI {
    
    static let shared = KhaltiAPI()
    
    func getBankList(onCompletion: @escaping (([List])->()), onError: @escaping ((String)->())) {
        let url = KhaltiAPIUrl.bankList.rawValue
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        headers["checkout-source"] = "iOS"
        headers["checkout-device-model"] = UIDevice.current.model
        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        headers["checkout-ios-version"] = UIDevice.current.systemVersion
        
        let request = Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headers)
        
        print("Request: \(url))")
        request.responseJSON { (responseJSON) in
            print("Response: \(url)")
            print(responseJSON)
            
            switch responseJSON.result {
            case .success(let value):
                var banks: [List] = []
                
                if let dict = value as? [String:Any], let records =  dict["records"] as? [[String:Any]]  {
                    for data in records {
                        if let bank = List(json: data) {
                            banks.append(bank)
                        }
                    }
                }
                
                if banks.count == 0 {
                    onError("No banks found")
                } else {
                    onCompletion(banks)
                }
            case .failure(let error):
                onError(error.localizedDescription)
                break
            }
        }
    }
    
    
    func getPaymentInitiate(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
        let url = KhaltiAPIUrl.paymentInitiate.rawValue
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        headers["checkout-source"] = "iOS"
        headers["checkout-device-model"] = UIDevice.current.model
        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        headers["checkout-ios-version"] = UIDevice.current.systemVersion
        
        let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
        
        print("Request: \(url))")
        print("Parameters: \(params)")
        request.responseJSON { (responseJSON) in
            print("Response: \(url)")
            print(responseJSON)
            
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
    
    func getPaymentConfirm(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
        
        let url = KhaltiAPIUrl.paymentConfirm.rawValue
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        headers["checkout-source"] = "iOS"
        headers["checkout-device-model"] = UIDevice.current.model
        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        headers["checkout-ios-version"] = UIDevice.current.systemVersion
        
        
        let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: headers)
        
        print("Request: \(url))")
        print("Parameters: \(params)")
        request.responseJSON { (responseJSON) in
            print("Response: \(url)")
            print(responseJSON)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
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

