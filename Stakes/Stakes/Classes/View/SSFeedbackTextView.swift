//
//  SSFeedbackTextView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 1/16/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSFeedbackTextView: UITextView {
    
    
    // MARK: Public Properties
    var charactersLimit: Int = 500
    var linesLimit: Int = 0 {
        willSet {
            textContainer.maximumNumberOfLines = newValue
        }
    }
    var isEmpty: Bool {
        return text == nil || text == ""
    }
    
    // MARK: Private Properties
    private let userDefaults = UserDefaults.standard
    private let keyFeedbackText = SSConstants.keys.kFeedbackText.rawValue
    
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settings()
    }
    
    
    // MARK: Private funcs
    private func settings() {
        
        font = UIFont(name: SSConstants.fontType.helvetica.rawValue, size: self.font!.pointSize)!
        autocapitalizationType = .sentences
        textContainer.maximumNumberOfLines = linesLimit
        textContainer.lineBreakMode = .byTruncatingTail
        textColor = UIColor.colorFrom(colorType: .createActionBlack)
        
        // Set value
        if let savedText = userDefaults.string(forKey: keyFeedbackText) {
            text = savedText
        }
    }
    
    
    // MARK: UITextViewDelegate funcs
    
    // Call for text saving in textViewDidEndEditing func of UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        
        text = textView.text
        userDefaults.set(textView.text, forKey: keyFeedbackText)
    }
    
    // Call for limit chars in shouldChangeCharactersIn func of UITextViewDelegate
    func setCharactersLimitFor(textView: UITextView, range: NSRange, string: String) -> Bool {
        
        // Check charachters limit
        let newText = NSString(string: textView.text).replacingCharacters(in: range, with: string)
        return newText.count < charactersLimit
    }
}
