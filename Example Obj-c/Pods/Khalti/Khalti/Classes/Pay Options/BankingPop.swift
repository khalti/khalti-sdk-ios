//
//  BankingPop.swift
//  Khalti
//
//  Created by Rajendra Karki on 3/30/18.
//

import Foundation

class BankingPop {
    
    public static func viewController() -> BankingPopViewController {
        let storyboard = UIStoryboard(name: "CheckOut", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "BankingPopViewController") as! BankingPopViewController
        return vc
    }
    
    private static var bundle:Bundle {
        let podBundle = Bundle(for: BankingPopViewController.self)
        let bundleURL = podBundle.url(forResource: "Khalti", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}
