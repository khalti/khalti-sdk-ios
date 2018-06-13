//
//  KaltiApi.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import UIKit
import Foundation

enum KhaltiAPIUrl: String {
    case ebankList = "https://khalti.com/api/bank/?has_ebanking=true&page_size=200"
    case cardBankList = "https://khalti.com/api/bank/?has_cardpayment=true&page_size=200"
    case paymentInitiate = "https://khalti.com/api/payment/initiate/"
    case paymentConfirm = "https://khalti.com/api/payment/confirm/"
    case bankInitiate = "https://khalti.com/ebanking/initiate/"
    case cardTerms = "https://khalti.com/api/termsandconditions/cardpayment/"
}

public enum ErrorMessage:String {
    case invalidUrl = "Invalid url. Please contact Khalti iOS support."
    case parse = "Unable to parse JSON Data"
    case noresponse = "Unable to get response"
    case server = "Khalti Server Error"
    case noAccess = "Access is denied"
    case badRequest = "Invalid data request"
    case tryAgain = "Something went wrong.Please try again later"
    case timeOut = "Request time out."
    case noConnection = "The internet connection appears to be offline."
}

class KhaltiAPI {
    
    static let shared = KhaltiAPI()
    static let logMessage:Bool = Khalti.shared.debugLog
    
    private func createRequest(for url:URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, forHTTPHeaderField: "checkout-version")
        request.setValue("iOS", forHTTPHeaderField: "checkout-source")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "checkout-device-model")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "checkout-device-id")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "checkout-ios-version")
        request.httpMethod = "GET"
        return request
    }
    
    func getBankList(banking: Bool = true, onCompletion: @escaping (([List])->()), onError: @escaping ((String)->())) {
        
        let urlValue:String = banking ? KhaltiAPIUrl.ebankList.rawValue : KhaltiAPIUrl.cardBankList.rawValue
        let urlString = urlValue
        guard let url = URL(string: urlString) else {
            onError(ErrorMessage.invalidUrl.rawValue)
            return
        }
    
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = self.createRequest(for: url)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            guard let data = data else {
                onError((error?.localizedDescription)!)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                onError(ErrorMessage.parse.rawValue)
                return
            }
            guard let responsee = response as? HTTPURLResponse else {
                onError(ErrorMessage.noresponse.rawValue)
                return
            }
            
            var banks: [List] = []
            if KhaltiAPI.logMessage {
                print("Status: \(responsee.statusCode), Response for: \(url)")
                print("===========================================================")
                print("\(json)")
                print("===========================================================")
            }
            
            if let dict = json as? [String:Any], let records =  dict["records"] as? [[String:Any]]  {
                for data in records {
                    if let bank = List(json: data) {
                        banks.append(bank)
                    }
                }
            } else {
                onError(error?.localizedDescription ?? ErrorMessage.tryAgain.rawValue)
            }
            
            if banks.count == 0 {
                onError("No banks found")
            } else {
                onCompletion(banks)
            }
        }
        task.resume()
    }
    
    func getCardTerms(onCompletion: @escaping (([String])->()), onError: @escaping ((String)->())) {
        
        let urlString:String = KhaltiAPIUrl.cardTerms.rawValue
        guard let url = URL(string: urlString) else {
            onError(ErrorMessage.invalidUrl.rawValue)
            return
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = self.createRequest(for: url)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            guard let data = data else {
                onError((error?.localizedDescription)!)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                onError(ErrorMessage.parse.rawValue)
                return
            }
            guard let responsee = response as? HTTPURLResponse else {
                onError(ErrorMessage.noresponse.rawValue)
                return
            }
            
            if KhaltiAPI.logMessage {
                print("Status: \(responsee.statusCode), Response for: \(url)")
                print("===========================================================")
                print("\(json)")
                print("===========================================================")
            }
            
            if let value = json as? [String] {
                onCompletion(value)
            } else {
                onError(error?.localizedDescription ?? ErrorMessage.tryAgain.rawValue)
            }
        }
        task.resume()
    }

    
    
    func getPaymentInitiate(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String,Dictionary<String,Any>?)->())) {
        
        if KhaltiAPI.logMessage {
            print(params)
        }
        
        let urlValue:String = KhaltiAPIUrl.paymentInitiate.rawValue
        let urlString = urlValue
        
        guard let url = URL(string: urlString) else {
            onError(ErrorMessage.invalidUrl.rawValue, nil)
            return
        }
        let configuration = URLSessionConfiguration.ephemeral
        var request = self.createRequest(for: url)
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.httpBody = data
            
        } catch let error {
            if KhaltiAPI.logMessage {
                print(error.localizedDescription)
            }
            onError(ErrorMessage.parse.rawValue, nil)
        }
        request.httpMethod = "POST"
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                onError((error?.localizedDescription)!, nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                onError(ErrorMessage.parse.rawValue, nil)
                return
            }
            
            guard let responsee = response as? HTTPURLResponse else {
                onError(ErrorMessage.noresponse.rawValue, nil)
                return
            }
            if KhaltiAPI.logMessage {
                print("Status: \(responsee.statusCode), Response for: \(url)")
                print("===========================================================")
                print("\(json)")
                print("===========================================================")
            }
            
            guard let dict = json as? [String:Any] else {
                onError(error?.localizedDescription ?? ErrorMessage.tryAgain.rawValue, nil)
                return
            }
            onCompletion(dict)
        }
        task.resume()
    }
    
    func getPaymentConfirm(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String, Dictionary<String,Any>?)->())) {
        if KhaltiAPI.logMessage {
            print(params)
        }
        let urlValue = KhaltiAPIUrl.paymentConfirm.rawValue
        let urlString = urlValue
        guard let url = URL(string: urlString) else {
            onError(ErrorMessage.invalidUrl.rawValue, nil)
            return
        }
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        var request = self.createRequest(for: url)
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.httpBody = data
        } catch let error {
            if KhaltiAPI.logMessage {
                print(error.localizedDescription)
            }
            onError(ErrorMessage.parse.rawValue, nil)
        }
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                onError((error?.localizedDescription)!, nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                onError(ErrorMessage.parse.rawValue, nil)
                return
            }
            guard let responsee = response as? HTTPURLResponse else {
                onError(ErrorMessage.noresponse.rawValue, nil)
                return
            }
            
            if KhaltiAPI.logMessage {
                print("Status: \(responsee.statusCode), Response for: \(url)")
                print("===========================================================")
                print("\(json)")
                print("===========================================================")
            }
            
            guard let dict = json as? [String:Any] else {
                onError(error?.localizedDescription ?? ErrorMessage.tryAgain.rawValue, nil)
                return
            }
            
            let statusCode = responsee.statusCode
            if statusCode == 200 {
                onCompletion(dict)
            } else if statusCode == 400 {
                if let errorMessage = dict["detail"] as? String {
                    onError(errorMessage, nil)
                } else if let nonFieldError = dict["non_field_error"] as? [String], nonFieldError.count > 0 {
                    let newValue = nonFieldError.joined(separator: "\n")
                    onError(newValue, nil)
                } else {
                    let newErrorDict = dict.map({ (key,value) -> String in
                        if let values = value as? [String] {
                            return key + ":" + values.joined(separator: ", ")
                        } else {
                            return key + ":" + ErrorMessage.badRequest.rawValue
                        }
                    })
                    let errorString = newErrorDict.joined(separator: "\n")
                    onError(errorString, dict)
                }
            } else {
                onError(error?.localizedDescription ?? ErrorMessage.tryAgain.rawValue, nil)
            }
        }
        task.resume()
    }
}

/*
 
 class KhaltiAPI {
 
 static let shared = KhaltiAPI()
 static let logMessage:Bool = true
 
 func getBankList(banking: Bool = true, onCompletion: @escaping (([List])->()), onError: @escaping ((String)->())) {
 let url = banking ? KhaltiAPIUrl.ebankList.rawValue : KhaltiAPIUrl.cardBankList.rawValue
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
 
 */
