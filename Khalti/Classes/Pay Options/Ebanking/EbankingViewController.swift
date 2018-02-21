//
//  EbankingViewController.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//

import UIKit

class EbankingViewController: UIViewController {

    // MARK: - Properties
    var config:Config?
    var delegate:KhaltiPayDelegate?
    var activityIndicator: UIActivityIndicatorView!
    var banks:[List] = []
    var filteredBanks:[List] = []
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var selectedBankButton: UIButton!
    @IBOutlet weak var selectedBankLabel: UILabel!
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.isHidden = true
        
        self.addLoading()
        self.showLoading()
        KhaltiAPI.shared.getBankList(onCompletion: { (banks) in
            self.hideLoading()
            self.banks = banks
            self.filteredBanks = self.banks
            self.listCollectionView.reloadData()
        }, onError: { errorMessage in
            self.hideLoading()
            self.delegate?.onCheckOutError(action: "", message: errorMessage)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        guard let config = self.config else  {
            let alertController = UIAlertController(title: "Missing Required Data", message: "Cannot process for payment.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK" , style: .default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        self.scrollView.layer.shadowColor = UIColor.black.cgColor
        self.scrollView.layer.shadowOpacity = 0.11
        self.scrollView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.scrollView.layer.shadowRadius = 1.0
        self.selectedBankButton.layer.cornerRadius = self.selectedBankButton.frame.size.height/2
        self.selectedBankButton.layer.masksToBounds = true
        
        
        let value = config.getAmount()
        self.payButton.setTitle("PAY Rs \(value/100)", for: .normal)
        
    }
    

    // MARK: - IBActions
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text, text != "" {
            let newList = self.banks.filter({ (list) -> Bool in
                return list.name?.lowercased().contains(text.lowercased()) ?? false || list.shortName?.lowercased().contains(text.lowercased()) ?? false
            })
            self.filteredBanks = newList
            if newList.count == 0 {
                self.filteredBanks = self.banks
            }
            self.listCollectionView.reloadData()
        }
    }
    
    @IBAction func mobileTextChanged(_ sender: UITextField) {
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.scrollView.isHidden = true
        self.listView.isHidden = false
    }
    
    @IBAction func payAction(_ sender: UIButton) {
//        let params = self.validate()
//        print(params)
        
        let url = URL(string: "http://192.168.1.211:8000/ebanking/initiate/?return_url=khalti.test_public_key_03a427da14344b1eabe56ce1f8a0a024&public_key=test_public_key_03a427da14344b1eabe56ce1f8a0a024&amount=2560&product_identity=rajendra&product_name=name")
        UIApplication.shared.openURL(url!)
    }
    
    
    // MARK: - Helpers
    
    func validate() -> Dictionary<String,Any> {
        var params:[String:Any] = [:]
        
        guard let mobile = self.mobileTextField.text, mobile != "" else {
            showError(with: "Mobile number empty", dismiss: false)
            return [:]
        }
        
        let cellRegex = NSPredicate(format:"SELF MATCHES %@", "^([9][678][0-9]{8})$")
        if cellRegex.evaluate(with: mobile) {
            params["mobile"] = mobile
        } else {
            showError(with: "Invalid contact Number", dismiss: false)
            return [:]
        }
        
        guard let publicKey = self.config?.getPublicKey() else {
            showError(with: "Public key missing")
            return [:]
        }
        params["public_key"] = publicKey
        
        guard let amount = self.config?.getAmount() else {
            showError(with: "Amount not found")
            return [:]
        }
        params["amount"] = amount
        
        guard let productID = self.config?.getProductId() else {
            showError(with: "Amount not found")
            return [:]
        }
        params["product_identity"] = productID
        
        guard let productName = self.config?.getProductName() else {
            showError(with: "Amount not found")
            return [:]
        }
        params["product_name"] = productName
        
        if let value = self.config?.getProductUrl() {
            params["product_url"] = value
        }
        
        if let dict = self.config?.getAdditionalData() {
            for value in dict {
                if !value.key.contains("merchant_") {
                    showError(with: "Addition data must contain keyword start with \"merchant_\" to ")
                    return [:]
                }
                params[value.key] = value.value
            }
        }
        
        return params
    }
    
    func addLoading() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityIndicator = activityIndicator
    }
    
    func showLoading() {
        if let indicator = self.activityIndicator {
            indicator.startAnimating()
            activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
        }
    }
    
    func hideLoading() {
        if let indicator = self.activityIndicator {
            indicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    // MARK: - Alert
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

extension EbankingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let landscape = UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft
        let ipad = UIDevice.current.userInterfaceIdiom == .pad
        let numberOfColumn:CGFloat = ipad ? (landscape ? 6 : 4 ) : (landscape ? 5 : 3 )
        let collectionViewCellSpacing:CGFloat = 10
        let cellHeight:CGFloat = 125
        
        let multiplier = (numberOfColumn-1)
        let cellWidth:CGFloat = ( self.view.frame.size.width - 24 - multiplier*collectionViewCellSpacing)/numberOfColumn
        let size = CGSize(width: cellWidth, height:cellHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredBanks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.filteredBanks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListCell
        cell.itemNameLabel.text = data.name
        cell.setImage(with: data.logo, name: data.shortName!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        func assign(name:String) {
            self.selectedBankButton.setImage(nil, for: .normal)
            self.selectedBankButton.setTitle(name, for: .normal)
        }
        
        if let image = self.filteredBanks[indexPath.row].logo {
            let urll = URL(string: image)
            let data = try? Data(contentsOf: urll!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.selectedBankButton.setImage(image, for: .normal)
                self.selectedBankButton.setTitle(nil, for: .normal)
            } else if let name = self.filteredBanks[indexPath.row].shortName {
                assign(name: name)
            }
        } else if let name = self.filteredBanks[indexPath.row].shortName {
            assign(name: name)
        }
        
        if let name = self.filteredBanks[indexPath.row].name {
            self.selectedBankLabel.text = name
        }
        
        self.scrollView.isHidden = false
    }

}
