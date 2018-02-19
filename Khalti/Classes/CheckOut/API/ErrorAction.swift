//
//  ErrorAction.swift
//  Alamofire
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation


enum ErrorActionType:String {
    case walletInitiate = "wallet_initiate"
    case walletConfirm = "wallet_confirm"
    case fetchBankList = "fetch_bank_list"
    
    public struct ErrorAction {
        
        private var  action:ErrorActionType
        
        init(action:ErrorActionType) {
            self.action = action
        }
        
        public func getAction() -> String {
            return self.action.rawValue
        }
    }
}


