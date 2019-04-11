//
//  EbankingViewController.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/19/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import UIKit

class EbankingViewController: UIViewController {
    
    // MARK: - Properties
    @objc var config:Config?
    @objc var delegate:KhaltiPayDelegate?
    @objc var activityIndicator: UIActivityIndicatorView!
    var banks:[List] = []
    @objc var terms:[String] = [
        "The first 3 transactions are free of cost.",
        "You can load a maximum amount of upto Rs.16,000 at once.",
        "For SCT cards, a service charge of 2% (maximum amount Rs.25) will be levied after the first 3 transactions.",
        "For all other cards, a service charge of 2% will be levied after the first 3 transactions.",
        "For non SCT Cards, make sure your card has been enabled for online payments by your bank."
    ]
    var selectedBank: List?
    var filteredBanks:[List] = []
    var loadType:KhaltiAPIUrl = .ebankList
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    @objc internal var isFetching:Bool = true
    @objc internal let refreshControl = UIRefreshControl()
    
    private lazy var noLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.textColor = KhaltiColor.base
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addLoading()
        self.getBankList()
        
        if #available(iOS 10.0, *) {
            listCollectionView.refreshControl = refreshControl
        } else {
            listCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func getBankList() {
        self.showLoading()
        switch loadType {
        case .cardBankList:
            KhaltiAPI.shared.getBankList(banking: false, onCompletion: { (banks) in
                self.refreshControl.endRefreshing()
                self.hideLoading()
                self.banks = banks
                self.filteredBanks = self.banks
                if self.filteredBanks.count == 0 {
                    self.noLabel.text = "No Banks with card payment found. \n Pull to refresh."
                    self.listCollectionView.backgroundView = self.noLabel
                } else {
                    self.listCollectionView.backgroundView = nil
                }
                self.listCollectionView.reloadData()
            }, onError: { errorMessage in
                if self.filteredBanks.count == 0 {
                    self.noLabel.text = "Unable to fetch Banks now. \n Pull to refresh."
                    self.listCollectionView.backgroundView = self.noLabel
                } else {
                    self.listCollectionView.backgroundView = nil
                }
                self.refreshControl.endRefreshing()
                self.hideLoading()
            })
            KhaltiAPI.shared.getCardTerms(onCompletion: { (response) in
                self.terms = response
            }, onError: { _ in
                
            })
            
        default:
            KhaltiAPI.shared.getBankList(onCompletion: { (banks) in
                self.refreshControl.endRefreshing()
                self.hideLoading()
                self.banks = banks
                self.filteredBanks = self.banks
                if self.filteredBanks.count == 0 {
                    self.noLabel.text = "No Banks found. \n Pull to refresh."
                    self.listCollectionView.backgroundView = self.noLabel
                } else {
                    self.listCollectionView.backgroundView = nil
                }
                self.listCollectionView.reloadData()
            }, onError: { errorMessage in
                if self.filteredBanks.count == 0 {
                    self.noLabel.text = "Unable to fetch Banks now. \n Pull to refresh."
                    self.listCollectionView.backgroundView = self.noLabel
                } else {
                    self.listCollectionView.backgroundView = nil
                }
                self.refreshControl.endRefreshing()
                self.hideLoading()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = self.config else  {
            let errorMessage = "Missing required data! Cannot process for payment."
            self.delegate?.onCheckOutError(action: "Ebanking", message: errorMessage, data: nil)
            showError(with: errorMessage, dismiss: true)
            return
        }
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        self.isFetching = true
        self.getBankList()
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
    
    @objc internal func payAction(with mobile:String) {
        var params = self.validate(with: mobile)
        print(params)
        if params.count == 0 {
            return
        }
        if let intent:String = Khalti.shared.appUrlScheme {
            Khalti.shared.canOpenUrl = true
            params.append(URLQueryItem(name: "source", value: "ios"))
            params.append(URLQueryItem(name: "return_url", value: intent))
            switch self.loadType {
            case .cardBankList:
                params.append(URLQueryItem(name: "is_card_payment", value: "true")) // For card payment
            default:
                break
            }
            var urlComp = URLComponents(string: KhaltiAPIUrl.bankInitiate.rawValue)
            urlComp?.queryItems = params
            
            
            if let urll = urlComp?.url {
                if UIApplication.shared.canOpenURL(urll) {
                    UIApplication.shared.openURL(urll)
                } else {
                    self.showError(with: "Unable to open your request.", dismiss: false)
                }
            } else {
                self.showError(with: "Unable to open your request.", dismiss: false)
            }
        } else {
            self.showError(with: "No Scheme defined yet", dismiss: false)
        }
    }
    
    
    
    
    // MARK: - Helpers
    
    private func validate(with mobile:String) -> [URLQueryItem] {
        var params:[URLQueryItem] = []
        params.append(URLQueryItem(name: "mobile", value: mobile))
        
        guard let bankId = self.selectedBank?.idx else {
            showError(with: "Bank not selected.")
            return []
        }
        
        params.append(URLQueryItem(name: "bank", value: bankId))
        
        guard let publicKey = self.config?.getPublicKey() else {
            showError(with: "Public key missing")
            return []
        }
        
        params.append(URLQueryItem(name: "public_key", value: publicKey))
        
        guard let amount = self.config?.getAmount() else {
            showError(with: "Amount not found")
            return []
        }
        params.append(URLQueryItem(name: "amount", value: "\(amount)"))
        
        guard let productID = self.config?.getProductId() else {
            showError(with: "Product Id missing.")
            return []
        }
        params.append(URLQueryItem(name: "product_identity", value: productID))
        
        guard let productName = self.config?.getProductName() else {
            showError(with: "Product Name missing.")
            return []
        }
        params.append(URLQueryItem(name: "product_name", value: productName))
        
        if let value = self.config?.getProductUrl() {
            params.append(URLQueryItem(name: "product_url", value: value))
        }
        
        if let dict = self.config?.getAdditionalData() {
            for value in dict {
                if !value.key.contains("merchant_") {
                    showError(with: "Addition data must contain keyword start with \"merchant_\" to ")
                    return []
                }
                params.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        
        return params
    }
    
    @objc func addLoading() {
        #if swift(>=4.2)
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        #else
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        #endif
        activityIndicator.color = UIColor.black
        self.activityIndicator = activityIndicator
    }
    
    @objc func showLoading() {
        if let indicator = self.activityIndicator {
            indicator.startAnimating()
            activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
        }
    }
    
    @objc func hideLoading() {
        if let indicator = self.activityIndicator {
            indicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    // MARK: - Alert
    @objc internal func showError(with message:String, dismiss:Bool = true) {
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
        cell.setImage(with: data.logo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedBank = self.filteredBanks[indexPath.row]
        self.presentLoad()
    }
}

extension EbankingViewController: UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.alpha = 1.0
    }
    
    @objc func presentLoad() {
        let popoverVC = BankingPop.viewController()
        
        popoverVC.modalPresentationStyle = UIModalPresentationStyle.popover
        let popoverController = popoverVC.popoverPresentationController
        popoverController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        popoverController?.delegate = self
        popoverController?.sourceView = self.view
        popoverController?.sourceRect = CGRect(x: 0, y: self.view!.bounds.height, width: 0.1, height: 0.1)
        
        popoverVC.preferredContentSize = CGSize(width: self.view!.bounds.width, height: 312)
        switch self.loadType {
        case .cardBankList:
            popoverVC.preferredContentSize = CGSize(width: self.view!.bounds.width, height: 392)
            popoverVC.terms = self.terms
        default:
            break
        }
        
        popoverVC.delegate = self
        popoverVC.bankName = self.selectedBank?.name
        popoverVC.bankShortName = self.selectedBank?.shortName
        popoverVC.bankLogo = self.selectedBank?.logo
        
        if let amount = config?.getAmount() {
            popoverVC.amount = amount
        }
        
        self.present(popoverVC,animated: true, completion: {
            self.view!.alpha = 0.3
        })
    }
}

extension EbankingViewController: BankingPopDelegate {
    @objc func eBankingloadActivated(with mobile: String) {
        self.view!.alpha = 1.0
        self.payAction(with: mobile)
    }
}
