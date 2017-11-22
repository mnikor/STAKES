//
//  SSGoalTextField.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSGoalTextField: SSBaseTextField {

    
    // MARK: Private Properties
    private let charactersLimit = 70
    
    
    // MARK: Public Funcs
    
    // Call in textFieldDidEndEditing func of UITextFieldDelegate
    func setTextFrom(_ textField: UITextField) {
        text = textField.text
    }
    
    // Call in shouldChangeCharactersIn func of UITextFieldDelegate
    func setCharactersLimitFor(textField: UITextField, range: NSRange, string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return newText.count < charactersLimit
    }
}
