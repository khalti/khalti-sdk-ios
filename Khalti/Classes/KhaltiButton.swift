//
//  KhaltiButton.swift
//  Khalti
//
//  Created by Rajendra Karki on 2/15/18.
//  Copyright (c) 2018 khalti. All rights reserved.
//

import UIKit

@objc protocol KhaltiPayDelegate {
    @objc optional func set(khatiButton: KhaltiButton) -> String
    @objc optional func setCustomView(khatiButton: KhaltiButton, view:UIView)
    @objc optional func showCheckOut(khatiButton: KhaltiButton )
    @objc optional func destroyCheckOut(khatiButton: KhaltiButton)
}

protocol KhaltiPayDatasource {
    func config(khatiButton: KhaltiButton) -> Config
}

class KhaltiButton: UIButton {
    
    public var delegate:KhaltiPayDelegate?
    public var dataSource:KhaltiPayDatasource?
    private var config:Config?

    fileprivate var lines: [CAShapeLayer]!
    @IBInspectable open var lineColor: UIColor! = UIColor(red: 250/255, green: 120/255, blue: 68/255, alpha: 1.0) {
        didSet {
            for line in lines {
                line.strokeColor = lineColor.cgColor
            }
        }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        self.setImage(#imageLiteral(resourceName: "ebanking_dark.png"), for: .normal)
        self.addTarget(self, action: #selector(payNow(_:)), for: .touchUpInside)
        self.config = self.dataSource?.config(khatiButton: self)
    }
    
    public override convenience init(frame: CGRect) {
        self.init(frame: frame)
    }

    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    // MARK: - Lifecyle
    override open func awakeFromNib() {
        
        
    }
    
    func payNow(_ sender: UIButton){
        
    }
    
    
    
    
    
}
