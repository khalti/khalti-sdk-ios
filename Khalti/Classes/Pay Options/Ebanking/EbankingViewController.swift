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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addLoading()
        self.showLoading()
        KhaltiAPI.shared.getBankList(onCompletion: { (banks) in
            self.hideLoading()
            self.banks = banks
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

    // MARK: - IBActions
    
    
    // MARK: - Helpers
    
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
    
}

extension EbankingViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let landscape = UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft
        let ipad = UIDevice.current.userInterfaceIdiom == .pad
        let numberOfColumn:CGFloat = ipad ? (landscape ? 6 : 4 ) : (landscape ? 5 : 3 )
        let collectionViewCellSpacing:CGFloat = 10
        let cellHeight:CGFloat = 100
        
        if indexPath.section != 0 {
            let multiplier = (numberOfColumn-1)
            let cellWidth:CGFloat = ( self.view.frame.size.width - 16 - multiplier*collectionViewCellSpacing)/numberOfColumn
            let size = CGSize(width: cellWidth, height:cellHeight)
            return size
        } else {
            let size = CGSize(width: self.view.frame.size.width, height:115)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.banks[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListCell
        cell.itemNameLabel.text = data.name
        cell.setImage(with: data.logo, name: data.shortName!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}
