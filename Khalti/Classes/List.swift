//
//  List.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/21/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import Foundation


public struct List {
    var idx:String?
    var name:String?
    var shortName:String?
    var logo:String?
    var address:String?
    var hasCardPayment:Bool?
    var hasEbanking:Bool?
    var hasDirectWithdraw:Bool?
    var hasNCHL:Bool?
}

extension List {
    public init?(json: [String: Any]) {
        guard let idx = json["idx"] as? String,
            let name = json["name"] as? String,
            let shortName = json["short_name"] as? String else {
                return nil
        }
        self.idx = idx
        self.name = name
        self.shortName = shortName
        
        if let value = json["logo"] as? String, value != "" {
            self.logo = value
        }
        if let value = json["address"] as? String {
            self.address = value
        }
        if let value = json["has_cardpayment"] as? Bool {
            self.hasCardPayment = value
        }
        if let value = json["has_ebanking"] as? Bool {
            self.hasEbanking = value
        }
        if let value = json["has_direct_withdraw"] as? Bool {
            self.hasDirectWithdraw = value
        }
        if let value = json["has_nchl"] as? Bool {
            self.hasNCHL = value
        }
        
    }
}
