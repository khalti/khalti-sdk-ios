//
//  CheckOutDelegate.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import Foundation

@objc public protocol KhaltiPayDelegate {
    func onCheckOutSuccess(data: Dictionary<String,Any>)
    func onCheckOutError(action:String, message:String, data:Dictionary<String,Any>?)
}
