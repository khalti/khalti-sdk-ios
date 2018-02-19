//
//  KaltiApi.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON

enum ErrorMessage:String {
    case server = "Internal Server Error"
    case noAccess = "Access is denied"
    case badRequest = "Invalid data request"
    case tryAgain = "Something went wrong.Please try again later"
    case timeOut = "Request time out."
    case noConnection = "No internet Connection."
}

class KhaltiApi {
    
    static let shared = KhaltiApi()
    
    internal let baseUrl: String = "a.khalti.com/api/"
    
    fileprivate let _manager: SessionManager = {
        let appVerion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let osVersion = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        
        let configuration = URLSessionConfiguration()
        
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["AppKey"]       = "yourappkey"
        headers["AppVersion"]   = appVerion
        headers["OS"]           = "iOS \(osVersion)"
        headers["DeviceModel"]  = deviceModel
        headers["DeviceID"]     = deviceID ?? ""
        headers["Content-Type"] = "application/json"
        headers["Accept"]       = "application/json"
        
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 30
        
        return  SessionManager(configuration: configuration)
    }()
    
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        requiresAuthorization: Bool = true)
        -> DataRequest {
            
            let newUrl: URLConvertible = url
            
            var headers = headers ?? [:]
            return self._manager.request(newUrl, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}



//MARK: Non-array response handle
extension DataRequest {
    
    /// Handle Request with success and error following Mappable Protocol and failure with Dictionary
    func handle<T:Mappable, K: Mappable> (success: @escaping (T)-> Void, error: @escaping (K)-> Void, failure: @escaping (String) -> (), dictionary: ((Dictionary<String,Any>) -> Void)? = nil) {
        
        self.responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else {
                if let err = response.error  {
                    print(err.localizedDescription)
                    failure(ErrorMessage.tryAgain.rawValue)
                    return
                }
                failure(ErrorMessage.tryAgain.rawValue)
                return
            }
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                switch statusCode {
                case 200..<300 :
                    if let value: T = json.map() {
                        success(value)
                    }
                    
                case 400:
                    guard let data =  response.data else {
                        failure(ErrorMessage.badRequest.rawValue)
                        return
                    }
                    let json = JSON(data)
                    if let data:K = json.map() {
                        error(data)
                    }
                    
                case 401:
                    if let data: FormError<K> = json.map() {
                        if let detail = data.detail {
                            error(detail)
                        } else if let value: K = json.map() {
                            error(value)
                        } else {
                            failure(ErrorMessage.tryAgain.rawValue)
                        }
                    }
                    
                case 403:
                    failure(ErrorMessage.noAccess.rawValue)
                case 500:
                    failure(ErrorMessage.server.rawValue)
                    
                default:
                    guard let err = response.error  else {
                        if let data: K = json.map() {
                            error(data)
                            return
                        }
                        failure(ErrorMessage.tryAgain.rawValue)
                        return
                    }
                    print(err.localizedDescription)
                    failure(ErrorMessage.tryAgain.rawValue)
                    break
                }
                
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    failure(ErrorMessage.timeOut.rawValue)
                } else {
                    print(error.localizedDescription)
                    failure(ErrorMessage.tryAgain.rawValue)
                }
            }
        }
    }
    
    func getDictionary(completion: @escaping (Dictionary<String,Any>)-> Void) {
        self.responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String,Any>{
                completion(dict)
            }
        }
    }
}

extension DataRequest {
    
    func handle<T: Mappable,K:Mappable>(success: @escaping ([T])-> Void, error: @escaping (K)-> Void, failure: @escaping (String) -> (), dictionary: ((Dictionary<String,Any>) -> Void)? = nil) {
        
        self.validate().responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else {
                if let err = response.error  {
                    print(err.localizedDescription)
                    failure(ErrorMessage.tryAgain.rawValue)
                    return
                }
                failure(ErrorMessage.tryAgain.rawValue)
                return
            }
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                switch statusCode {
                case 200..<300 :
                    if let value: [T] = json.map() {
                        success(value)
                    }
                    
                case 400:
                    guard let data =  response.data else {
                        failure(ErrorMessage.badRequest.rawValue)
                        return
                    }
                    
                    let json = JSON(data)
                    if let data:K = json.map() {
                        error(data)
                        break
                    }
                case 401:
                    if let data: FormError<K> = json.map() {
                        if let detail = data.detail {
                            error(detail)
                        } else {
                            failure(ErrorMessage.badRequest.rawValue)
                        }
                    }
                case 403:
                    failure(ErrorMessage.noAccess.rawValue)
                case 500:
                    failure(ErrorMessage.server.rawValue)
                    
                default:
                    guard let err = response.error  else {
                        if let data: K = json.map() {
                            error(data)
                            return
                        }
                        failure(ErrorMessage.tryAgain.rawValue)
                        return
                    }
                    print(err.localizedDescription)
                    failure(ErrorMessage.tryAgain.rawValue)
                    break
                }
                
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    failure(ErrorMessage.timeOut.rawValue)
                } else {
                    print(error.localizedDescription)
                    failure(ErrorMessage.tryAgain.rawValue)
                }
            }
        }
    }
}
