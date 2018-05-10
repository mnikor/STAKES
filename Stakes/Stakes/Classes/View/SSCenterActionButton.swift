//
//  SSCenterActionButton.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/24/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSCenterActionButton: SSBaseButton {
    
    // MARK: Public properties
    var titleColor: UIColor?
    
    
    // MARK: Overriden funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var color = UIColor()
        
        if isEnabled {
            color = UIColor.colorFrom(colorType: .red)
        } else {
            color = UIColor.colorFrom(colorType: .light)
        }
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.height / 2
        self.makeBorder(width: .small, color: color)
        
        tintColor = titleColor != nil ? titleColor! : color
        backgroundColor = .white
    }
}
