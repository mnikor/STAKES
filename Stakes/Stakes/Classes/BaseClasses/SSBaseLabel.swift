//
//  SSBaseLabel.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseLabel: UILabel {
    
    
    // MARK: Private Properties
    private let colorLabel = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
    private var fontLabel:UIFont { return UIFont(name: SSConstants.font, size: self.font.pointSize)! }
    
    
    // MARK: Initializers
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    
    // MARK: Overriden funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    // MARK: Private funcs
    private func setup() {
        
        textColor = colorLabel
        font = fontLabel
    }
}
