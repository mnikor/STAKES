//
//  SSBaseButton.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/22/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseButton: UIButton {
    
    
    // MARK: Private Properties
    private var fontLabel:UIFont { return UIFont(name: SSConstants.fontType.bigCaslon.rawValue, size: self.titleLabel!.font.pointSize)! }
    
    
    // MARK: Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.font = fontLabel
    }
    
    
    // MARK: Public funcs
    func makeBorder(width: CircleBorderSize, color: UIColor) {
        
        layer.borderColor = color.cgColor
        layer.borderWidth = width.rawValue
    }
}
