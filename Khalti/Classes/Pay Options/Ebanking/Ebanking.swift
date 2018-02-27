//
//  EbankingWireframe.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import Foundation

class Ebanking {
    
    public static func viewController() -> EbankingViewController {
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
