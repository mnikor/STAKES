//
//  SSStakeTextField.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

// TODO: Delete if unused
class SSStakeTextField: SSBaseTextField {
    
    
    // MARK: Public Properties
    var selectedPrice: Float {
        
        guard var newText = text else {
//            point.currentPoints = 0.0
            return 0.0
        }
        
        if newText == "" {
            newText = "0.00"
        }
        let stake = Float(newText)!
        return stake
    }
    
    
    // MARK: Private Properties
    private var stake = 0
    
    // MARK: Public Funcs
    
    // Call in textFieldDidEndEditing func of UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let newStake = Int(selectedPrice)
        
//        SSPoint().currentPoints = newStake
        self.text = "$\(newStake)"
    }
    
    // Call in shouldChangeCharactersIn func of UITextFieldDelegate
    func setCharactersLimitFor(textField: UITextField, range: NSRange, string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        let regex = try? NSRegularExpression(pattern: "^\\d{0,3}(\\.\\d{0,2})?$", options: [])
        return regex?.firstMatch(in: newText, options: [], range: NSRange(location: 0, length: newText.count)) != nil
    }
}
