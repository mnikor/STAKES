//
//  SSPriceTextField.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSPriceTextField: SSBaseTextField {
    
    
    // MARK: Public Properties
    var selectedPrice: Float?
    
    
    // MARK: Public Funcs
    
    // Call in textFieldDidEndEditing func of UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var newText = textField.text else { return }
        
        if newText == "" {
            newText = "0.00"
        }
        self.text = "$\(newText)"
        selectedPrice = Float(newText)
    }
    
    // Call in shouldChangeCharactersIn func of UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        let regex = try? NSRegularExpression(pattern: "^\\d{0,3}(\\.\\d{0,2})?$", options: [])
        return regex?.firstMatch(in: newText, options: [], range: NSRange(location: 0, length: newText.count)) != nil
    }
}
