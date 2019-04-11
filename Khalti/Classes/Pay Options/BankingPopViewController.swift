//
//  BankingPopViewController.swift
//  Khalti
//
//  Created by Rajendra Karki on 3/29/18.
//  Copyright © 2018 Khalti. All rights reserved.
//

import UIKit

protocol BankingPopDelegate {
    func eBankingloadActivated(with mobile:String)
}

class BankingPopViewController: UIViewController {
    
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var termsTableView:UITableView!
    @IBOutlet weak var selectedBankButton: UIButton!
    @IBOutlet weak var selectedBankLabel: UILabel!
    
    var bankName:String?
    var bankShortName:String?
    var bankLogo:String?
    var delegate: BankingPopDelegate?
    var amount:Int = 0
    var image:UIImage?
    var terms:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = self.bankName, let shortName = self.bankShortName {
            if name.count > 24 {
                self.selectedBankLabel.text = shortName
            } else {
                self.selectedBankLabel.text = name
            }
        }
        self.setImage(with: self.bankLogo)
        self.payButton.setTitle("PAY Rs \(amount/100)", for: .normal)
        image = UIImage(named: "khalti_small")
    }
    
    private func setImage(with url:String?) {
        if let imageUrl = url, let urll = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: urll) { [weak self] (data, response, error) in
                if let e = error {
                    self?.selectedBankButton.setImage(self?.image, for: .normal)
                    if Khalti.shared.debugLog {
                        print("Error downloading bank logo: \(e)")
                    }
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let imagee = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self?.selectedBankButton.setImage(imagee, for: .normal)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self?.selectedBankButton.setImage(self?.image, for: .normal)
                            }
                            if Khalti.shared.debugLog {
                                print("Couldn't get image: Image is nil")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.selectedBankButton.setImage(self?.image, for: .normal)
                        }
                        if Khalti.shared.debugLog {
                            print("Couldn't get response code for some reason")
                        }
                    }
                }
            }
            downloadPicTask.resume()
        } else {
            self.selectedBankButton.setImage(image, for: .normal)
        }
    }
    
    @IBAction func payAction(_ sender: UIButton) {
        
        guard let mobile = self.mobileTextField.text, mobile != "" else {
            showError(with: "Mobile number empty", dismiss: false)
            return 
        }
        
        let cellRegex = NSPredicate(format:"SELF MATCHES %@", "^([9][678][0-9]{8})$")
        if !cellRegex.evaluate(with: mobile) {
            showError(with: "Invalid contact Number", dismiss: false)
            return
        }
        
        self.dismiss(animated: true) {
            self.delegate?.eBankingloadActivated(with: mobile)
        }
    }
    
    private func showError(with message:String, dismiss:Bool = true) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK" , style: .default, handler: {_ in
            if dismiss {
                self.dismiss(animated: true, completion: nil)
            }
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension BankingPopViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count == 0 ? 0 : terms.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        if indexPath.row == 0 {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor = KhaltiColor.orange
            cell.textLabel?.text = "*Terms & Conditions"
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            let row = self.terms.count > 0 ? indexPath.row-1 : indexPath.row
            cell.textLabel?.textColor = UIColor(red: 51/256, green: 51/256, blue: 51/256, alpha: 1.0)
            cell.textLabel?.text = "\(row+1). \(self.terms[row])"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        #if swift (>=4.2)
            return UITableView.automaticDimension
        #else
            return UITableViewAutomaticDimension
        #endif
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        #if swift (>=4.2)
            return UITableView.automaticDimension
        #else
            return UITableViewAutomaticDimension
        #endif
    }
}
