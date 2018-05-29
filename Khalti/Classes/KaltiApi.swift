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
}

enum ErrorMessage:String {
    case server = "Khalti Server Error"
    case noAccess = "Access is denied"
    case badRequest = "Invalid data request"
    case tryAgain = "Something went wrong.Please try again later"
    case timeOut = "Request time out."
    case noConnection = "No internet Connection."
}

//class KhaltiAPI {
//
//    static let shared = KhaltiAPI()
//    static let debug:Bool = true
//
//    func getBankList(banking: Bool = true, onCompletion: @escaping (([List])->()), onError: @escaping ((String)->())) {
//        let url = banking ? KhaltiAPIUrl.ebankList.rawValue : KhaltiAPIUrl.cardBankList.rawValue
//        var headers = Alamofire.SessionManager.defaultHTTPHeaders
//        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
//        headers["checkout-source"] = "iOS"
//        headers["checkout-device-model"] = UIDevice.current.model
//        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        headers["checkout-ios-version"] = UIDevice.current.systemVersion
//
//        let request = Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headers)
//
//        print("Request: \(url))")
//        request.responseJSON { (responseJSON) in
//            print("Response: \(url)")
//            print(responseJSON)
//
//            switch responseJSON.result {
//            case .success(let value):
//                var banks: [List] = []
//
//                if let dict = value as? [String:Any], let records =  dict["records"] as? [[String:Any]]  {
//                    for data in records {
//                        if let bank = List(json: data) {
//                            banks.append(bank)
//                        }
//                    }
//                }
//
//                if banks.count == 0 {
//                    onError("No banks found")
//                } else {
//                    onCompletion(banks)
//                }
//            case .failure(let error):
//                onError(error.localizedDescription)
//                break
//            }
//        }
//    }
//
//
//    func getPaymentInitiate(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
//        let url = KhaltiAPIUrl.paymentInitiate.rawValue
//        var headers = Alamofire.SessionManager.defaultHTTPHeaders
//        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
//        headers["checkout-source"] = "iOS"
//        headers["checkout-device-model"] = UIDevice.current.model
//        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        headers["checkout-ios-version"] = UIDevice.current.systemVersion
//
//        let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding(options: []), headers: headers)
//
//        print("Request: \(url))")
//        print("Parameters: \(params)")
//        request.responseJSON { (responseJSON) in
//            print("Response: \(url)")
//            print(responseJSON)
//
//            switch responseJSON.result {
//            case .success(let value):
//                if let dict = value as? Dictionary<String, Any> {
//                    onCompletion(dict)
//                }
//                break
//            case .failure(let error):
//                onError(error.localizedDescription)
//                break
//            }
//        }
//    }
//
//    func getPaymentConfirm(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
//
//        let url = KhaltiAPIUrl.paymentConfirm.rawValue
//        var headers = Alamofire.SessionManager.defaultHTTPHeaders
//        headers["checkout-version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
//        headers["checkout-source"] = "iOS"
//        headers["checkout-device-model"] = UIDevice.current.model
//        headers["checkout-device-id"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        headers["checkout-ios-version"] = UIDevice.current.systemVersion
//
//
//        let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: headers)
//
//        print("Request: \(url))")
//        print("Parameters: \(params)")
//        request.responseJSON { (responseJSON) in
//            print("Response: \(url)")
//            print(responseJSON)
//
//            switch responseJSON.result {
//            case .success(let value):
//                print(value)
//                if let dict = value as? Dictionary<String, Any> {
//                    onCompletion(dict)
//                }
//                break
//            case .failure(let error):
//                onError(error.localizedDescription)
//                break
//            }
//        }
//    }
//
//}

class KhaltiAPI {
    
    static let shared = KhaltiAPI()
    static let debug:Bool = false
    
    func getBankList(banking: Bool = true, onCompletion: @escaping (([List])->()), onError: @escaping ((String)->())) {
        
        let urlValue:String = banking ? KhaltiAPIUrl.ebankList.rawValue : KhaltiAPIUrl.cardBankList.rawValue
        let urlString = KhaltiAPI.debug ? urlValue.replacingOccurrences(of: "https://khalti.com", with: "http://a.khalti.com") : urlValue
        guard let url = URL(string: urlString) else {
            onError("Invalid url. Please contact Khalti iOS support.")
            return
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, forHTTPHeaderField: "checkout-version")
        request.setValue("iOS", forHTTPHeaderField: "checkout-source")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "checkout-device-model")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "checkout-device-id")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "checkout-ios-version")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            guard let data = data else {
                onError((error?.localizedDescription)!)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                onError("Unable to parse JSON Data")
                return
            }
            
            var banks: [List] = []
            print("===========================================================")
            print("Response for: \(url)")
            if let responsee = response as? HTTPURLResponse {
                print("Status Code: \(responsee.statusCode)")
            }
            print("\(json)")
            print("===========================================================")
            
            if let dict = json as? [String:Any], let records =  dict["records"] as? [[String:Any]]  {
                for data in records {
                    if let bank = List(json: data) {
                        banks.append(bank)
                    }
                }
            } else {
                onError(error?.localizedDescription ?? "Something went wrong")
            }
            
            if banks.count == 0 {
                onError("No banks found")
            } else {
                onCompletion(banks)
            }
        }
        task.resume()
    }
    
    
    func getPaymentInitiate(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
        
        let urlValue:String = KhaltiAPIUrl.paymentInitiate.rawValue
        let urlString = KhaltiAPI.debug ? urlValue.replacingOccurrences(of: "https://khalti.com", with: "http://a.khalti.com") : urlValue
        
        guard let url = URL(string: urlString) else {
            onError("Invalid url. Please contact Khalti iOS support.")
            return
        }
        let configuration = URLSessionConfiguration.ephemeral
        var request = URLRequest(url: url)
        request.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, forHTTPHeaderField: "checkout-version")
        request.setValue("iOS", forHTTPHeaderField: "checkout-source")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "checkout-device-model")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "checkout-device-id")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "checkout-ios-version")
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.httpBody = data
            
        } catch let error {
            print(error.localizedDescription)
            onError("Unable to handle input parameters.")
        }
        request.httpMethod = "POST"
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                onError((error?.localizedDescription)!)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                onError("Unable to parse JSON Data")
                return
            }
            
            print("===========================================================")
            print("Response for: \(url)")
            if let responsee = response as? HTTPURLResponse {
                print("Status Code: \(responsee.statusCode)")
            }
            print("\(json)")
            print("===========================================================")
            
            if let dict = json as? [String:Any] {
                onCompletion(dict)
            } else {
                onError(error?.localizedDescription ?? "Something went wrong")
            }
            
        }
        task.resume()
    }
    
    func getPaymentConfirm(with params: Dictionary<String,Any>, onCompletion: @escaping ((Dictionary<String,Any>)->()), onError: @escaping ((String)->())) {
        
        let urlValue = KhaltiAPIUrl.paymentConfirm.rawValue
        let urlString = KhaltiAPI.debug ? urlValue.replacingOccurrences(of: "https://khalti.com", with: "http://a.khalti.com") : urlValue
        guard let url = URL(string: urlString) else {
            onError("Invalid url. Please contact Khalti iOS support.")
            return
        }
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        var request = URLRequest(url: url)
        request.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, forHTTPHeaderField: "checkout-version")
        request.setValue("iOS", forHTTPHeaderField: "checkout-source")
        request.setValue(UIDevice.current.model, forHTTPHeaderField: "checkout-device-model")
        request.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "checkout-device-id")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "checkout-ios-version")
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.httpBody = data
        } catch let error {
            print(error.localizedDescription)
            onError("Unable to handle input parameters.")
        }
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                onError((error?.localizedDescription)!)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                onError("Unable to parse JSON Data")
                return
            }
            
            print("===========================================================")
            print("Response for: \(url)")
            if let responsee = response as? HTTPURLResponse {
                print("Status Code: \(responsee.statusCode)")
            }
            print("\(json)")
            print("===========================================================")
            
            if let dict = json as? [String:Any] {
                onCompletion(dict)
            } else {
                onError(error?.localizedDescription ?? "Something went wrong")
            }
            
        }
        task.resume()
    }
}
