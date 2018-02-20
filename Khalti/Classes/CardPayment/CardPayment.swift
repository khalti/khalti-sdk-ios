//
//  CardPaymentWireframe.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation


class CardPayment {
    
    public static func viewController() -> CardPaymentViewController {
        let storyboard = UIStoryboard(name: "CheckOut", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "CardPaymentViewController") as! CardPaymentViewController
        return vc
    }
    
    private static var bundle:Bundle {
        let podBundle = Bundle(for: CardPaymentViewController.self)
        let bundleURL = podBundle.url(forResource: "Khalti", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}
