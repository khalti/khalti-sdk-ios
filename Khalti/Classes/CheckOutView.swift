//
//  CheckOutView.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/15/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import UIKit

public class CheckOutViewController: UIViewController {
    
    public static func presentMe(caller: UIViewController) {
        let storyboard = UIStoryboard(name: "CheckOut", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController()!
        caller.present(vc, animated: true, completion: nil)
    }
    
    
    static var bundle:Bundle {
        let podBundle = Bundle(for: CheckOutViewController.self)
        let bundleURL = podBundle.url(forResource: "Khalti", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}
