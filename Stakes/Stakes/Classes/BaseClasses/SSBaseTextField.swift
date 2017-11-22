//
//  SSBaseTextField.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/16/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseTextField: UITextField {
    
    
    // MARK: Private Properties
    private var fontText:UIFont { return UIFont(name: SSConstants.font, size: self.font!.pointSize)! }
    
    
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
        
        font = fontText
    }
    
    
    // MARK: Public funcs
    
    // Call in textFieldShouldReturn func of UITextFieldDelegate
    func shouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        endEditing(true)
        return true
    }
}
