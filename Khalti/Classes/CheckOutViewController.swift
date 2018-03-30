//
//  CheckOutView.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/15/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import UIKit

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self.absoluteURL, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

class CheckOutViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstLine: UIView!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var thirdLine: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var config:Config?
    var delegate:KhaltiPayDelegate?
    
    private lazy var ebankingViewController:EbankingViewController = {
        let viewController = Ebanking.viewController()
        viewController.config = self.config
        viewController.delegate = self.delegate
        viewController.loadType = KhaltiAPIUrl.ebankList
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var khaltiPayViewController: KhaltiPaymentViewController = {
        let viewController = KhaltiPayment.viewController()
        viewController.config = self.config
        viewController.delegate = self.delegate
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var cardPayViewController: EbankingViewController = {
        let viewController = Ebanking.viewController()
        viewController.config = self.config
        viewController.delegate = self.delegate
        viewController.loadType = KhaltiAPIUrl.cardBankList
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.addBackButton()
        self.updateView(to: .ebanking)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handle(withNotification:)), name: Notification.Name(rawValue: Khalti.shared.appUrlScheme!), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = config, let _ = delegate else {
            let alertController = UIAlertController(title: "Missing Configuration", message: "Cannot process for payment.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK" , style: .default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
    }
    
    @objc func handle(withNotification notification : Notification) {
        if let url = notification.userInfo!["url"] as? URL {
            NotificationCenter.default.removeObserver(self, name:notification.name, object: nil)
            if let params = url.queryParameters {
                self.dismiss(animated: true, completion: {
                    self.delegate?.onCheckOutSuccess(data: params)
                })
            }
        }
        print("RECEIVED SPECIFIC NOTIFICATION: \(notification)")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addBackButton() {
        let menuBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action:  #selector(self.navigateBack))
        menuBarButtonItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = menuBarButtonItem
    }
    
    @objc func navigateBack() {
        self.dismiss(animated: true, completion: {
            // do pass navigation back data
            
        })
    }
    
    // MARK: - Actions
    @IBAction func ebankingPay(_ sender: UIButton) {
        self.updateView(to: .ebanking)
    }
    
    @IBAction func khaltiPay(_ sender: UIButton) {
        self.updateView(to: .khalti)
    }
    
    @IBAction func cardPay(_ sender: UIButton) {
        self.updateView(to: .card)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        addChildViewController(viewController) // Add Child View Controller
        containerView.addSubview(viewController.view) // Add Child View as Subview
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParentViewController: nil) // Notify Child View Controller
        viewController.view.removeFromSuperview() // Remove Child View From Superview
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    fileprivate func updateView(to:PaymentType) {
        let khaltiBaseColor = UIColor(red: 76.0/255.0, green: 39.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        let khaltiOrangeColor = UIColor(red:247.0/255.0, green: 147.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        self.firstButton.setTitleColor(khaltiBaseColor, for: .normal)
        self.firstLine.backgroundColor = UIColor.clear
        self.secondButton.setTitleColor(khaltiBaseColor, for: .normal)
        self.secondLine.backgroundColor = UIColor.clear
        self.thirdButton.setTitleColor(khaltiBaseColor, for: .normal)
        self.thirdLine.backgroundColor = UIColor.clear
        if to == .ebanking {
            UIView.animate(withDuration: 0.3, animations: {
                self.firstButton.setTitleColor(khaltiOrangeColor, for: .normal)
                self.firstLine.backgroundColor = khaltiOrangeColor
            })
            self.remove(asChildViewController: self.khaltiPayViewController)
            self.remove(asChildViewController: self.cardPayViewController)
            self.add(asChildViewController: self.ebankingViewController)
        } else if to == .khalti {
            UIView.animate(withDuration: 0.3, animations: {
                self.secondButton.setTitleColor(khaltiOrangeColor, for: .normal)
                self.secondLine.backgroundColor = khaltiOrangeColor
            })
            self.remove(asChildViewController: self.ebankingViewController)
            self.remove(asChildViewController: self.cardPayViewController)
            self.add(asChildViewController: self.khaltiPayViewController)
        } else if to == .card {
            UIView.animate(withDuration: 0.3, animations: {
                self.thirdButton.setTitleColor(khaltiOrangeColor, for: .normal)
                self.thirdLine.backgroundColor = khaltiOrangeColor
            })
            self.remove(asChildViewController: self.ebankingViewController)
            self.remove(asChildViewController: self.khaltiPayViewController)
            self.add(asChildViewController: self.cardPayViewController)
        }
    }
}


