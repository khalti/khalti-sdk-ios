//
//  KhaltiWireframe.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation

class KhaltiPaymentWireFrame {
    
    public static func createView() -> KhaltiPaymentViewController {
        let storyboard = UIStoryboard(name: "CheckOut", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "KhaltiPaymentViewController") as! KhaltiPaymentViewController
        return vc
    }
    
    private static var bundle:Bundle {
        let podBundle = Bundle(for: KhaltiPaymentViewController.self)
        let bundleURL = podBundle.url(forResource: "Khalti", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}
