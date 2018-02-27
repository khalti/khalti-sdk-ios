//
//  CheckOutDelegate.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation

@objc public protocol KhaltiPayDelegate {
    func onCheckOutSuccess(data: Dictionary<String,Any>)
    func onCheckOutError(action:String, message:String)
}
