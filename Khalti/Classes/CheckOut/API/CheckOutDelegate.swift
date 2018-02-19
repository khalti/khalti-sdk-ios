//
//  CheckOutDelegate.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation

public protocol CheckOutDelegate {
     func onSuccess(data: Dictionary<String,Any>)
     func onError(action:String, message:String)
}
