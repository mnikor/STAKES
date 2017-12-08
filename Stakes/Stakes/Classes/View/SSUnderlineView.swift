//
//  SSUnderlineView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/8/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSUnderlineView: UIView {
    
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCustomColor(color: .underlineView)
    }
    
    
    // MARK: Public funcs
    func setCustomColor(color: SSConstants.colorType, alpha: CGFloat? = nil) {
        
        var newColor = UIColor.colorFrom(colorType: color)
        
        if let newAlpha = alpha {
            newColor = newColor.withAlphaComponent(newAlpha)
        }
        backgroundColor = newColor
    }
}
