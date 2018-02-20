//
//  CheckOutView.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/15/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import UIKit

public enum PaymentType {
    case khalti
    case ebanking
    case card
}

struct KhaltiColor {
    static var base: UIColor  { return UIColor(red: 76.0/255.0, green: 39.0/255.0, blue: 109.0/255.0, alpha: 1.0) }
    static var orange: UIColor { return UIColor(red:247.0/255.0, green: 147.0/255.0, blue: 34.0/255.0, alpha: 1.0) }
}

public class Khalti {
    
    public static func present(caller: UIViewController, with config:Config) {
        let viewController = self.payView()
        viewController.config = config
        let navigationViewController = UINavigationController(rootViewController: viewController)
        
        navigationViewController.navigationBar.isTranslucent = false
        navigationViewController.navigationBar.barTintColor = UIColor(red: 76.0/255.0, green: 39.0/255.0, blue: 109.0/255.0, alpha: 1)
        navigationViewController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        caller.present(navigationViewController, animated: true, completion: nil)
    }
    
    fileprivate static func payView() -> CheckOutViewController {
        let storyboard = UIStoryboard(name: "CheckOut", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! CheckOutViewController
        return vc
    }
    
    private static var bundle:Bundle {
        let podBundle = Bundle(for: CheckOutViewController.self)
        let bundleURL = podBundle.url(forResource: "Khalti", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
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
    
    private lazy var ebankingViewController:EbankingViewController = {
        let vc = Ebanking.viewController()
        self.add(asChildViewController: vc)
        return vc
    }()
    
    private lazy var khaltiPayViewController: KhaltiPaymentViewController = {
        let vc = KhaltiPayment.viewController()
        self.add(asChildViewController: vc)
        return vc
    }()
    
    private lazy var cardPayViewController: CardPaymentViewController = {
        let vc = CardPayment.viewController()
        self.add(asChildViewController: vc)
        return vc
    }()
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
        
        self.addBackButton()
        self.updateView(to: .ebanking)
       
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


