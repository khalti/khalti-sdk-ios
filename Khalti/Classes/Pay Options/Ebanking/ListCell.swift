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
        
        if let imageUrl = url {
            let urll = URL(string: imageUrl)
            let data = try? Data(contentsOf: urll!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.imageTask(with: image, label: name)
            } else {
                self.imageTask(with: nil, label: name)
            }
            
//            // Creating a session object with the default configuration.
//            // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
//            let session = URLSession(configuration: .default)
//
//            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
//            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
//                // The download has finished.
//                if let e = error {
//                    print("Error downloading cat picture: \(e)")
//                    self.imageTask(label: name)
//                } else {
//                    // No errors found.
//                    // It would be weird if we didn't have a response, so check for that too.
//                    if let res = response as? HTTPURLResponse {
//                        print("Downloaded bank logo with response code \(res.statusCode)")
//                        if let imageData = data {
//                            // Finally convert that Data into an image and do what you wish with it.
//                            let image = UIImage(data: imageData)
//                            // Do something with your image.
//                            self.imageTask(with: image, label: name)
//                        } else {
//                            self.imageTask(label: name)
//                            print("Couldn't get image: Image is nil")
//                        }
//                    } else {
//                        self.imageTask(label: name)
//                        print("Couldn't get response code for some reason")
//                    }
//                }
//            }
//
//            downloadPicTask.resume()
        } else {
            self.imageTask(label: name)
        }
        
    }
    
    private func imageTask(with image:UIImage? = nil, label:String) {
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
