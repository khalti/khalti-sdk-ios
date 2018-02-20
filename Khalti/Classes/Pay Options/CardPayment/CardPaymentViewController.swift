//
//  CardPaymentViewController.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//

import UIKit

class CardPaymentViewController: UIViewController {

    var config:Config?
    var delegate:KhaltiPayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let config = self.config else {
            let alertController = UIAlertController(title: "Missing Required Data", message: "Cannot process for payment.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK" , style: .default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
    }

}
