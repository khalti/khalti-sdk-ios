//
//  ListCell.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/21/18.
//

import Foundation
import UIKit

class ListCell: UICollectionViewCell {
    
    var itemImageView:UIImageView!
    var itemNameLabel: UILabel!
    var itemButton: UIButton!
    
    override func awakeFromNib() {
        // Please check Main.storyboard with PaymentCell for the tag.
        itemImageView = self.viewWithTag(201) as! UIImageView
        itemNameLabel = self.viewWithTag(202) as! UILabel
        itemButton = self.viewWithTag(203) as! UIButton
    }
    
    func setImage(with url:String?, name:String) {
        
        if let imageUrl = url, let urll = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: urll) { (data, response, error) in
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                    self.imageTask(label: name)
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.imageTask(with: image, label: name)
                        } else {
                            self.imageTask(label: name)
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        self.imageTask(label: name)
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
        } else {
            self.imageTask(label: name)
        }
    }
    
    private func imageTask(with image:UIImage? = nil, label:String) {
        DispatchQueue.main.async {
            if let image = image {
                self.itemButton.isHidden = true
                self.itemImageView.isHidden = false
                self.itemImageView.image = image
            } else {
                self.itemButton.layer.cornerRadius = self.itemButton.frame.size.height/2
                self.itemButton.layer.masksToBounds = true
                self.itemImageView.isHidden = true
                self.itemButton.isHidden = false
                self.itemButton.setTitle(label, for: .normal)
                self.itemButton.setImage(nil, for: .normal)
            }
        }
    }  
}
