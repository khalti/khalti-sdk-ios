//
//  EbankingWireframe.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//

import Foundation

class EbankingWireFrame {
    
    public static func createView() -> EbankingViewController {
        let storyboard = UIStoryboard(name: "CheckOut", bundle: bundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "EbankingViewController") as! EbankingViewController
        return vc
    }
    
    private static var bundle:Bundle {
        let podBundle = Bundle(for: EbankingViewController.self)
        let bundleURL = podBundle.url(forResource: "Khalti", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}
