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
    var charactersLimit: Int = 200
    var linesLimit: Int = 0 {
        willSet {
            textContainer.maximumNumberOfLines = newValue
        }
    }
    var isEmpty: Bool {
        return text == nil || text == ""
    }
    
    
    // MARK: Private Properties
    private var fontText:UIFont { return UIFont(name: SSConstants.fontType.helvetica.rawValue, size: self.font!.pointSize)! }
    
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settings()
    }
    
    
    // MARK: Private funcs
    private func settings() {
        
        font = fontText
        autocapitalizationType = .sentences
        textContainer.maximumNumberOfLines = linesLimit
        textContainer.lineBreakMode = .byTruncatingTail
        textColor = UIColor.colorFrom(colorType: .createActionBlack)
    }
    
    
    // MARK: UITextViewDelegate funcs
    
    // Call for text saving in textViewDidEndEditing func of UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        
        text = textView.text
    }
    
    // Call for limit chars in shouldChangeCharactersIn func of UITextViewDelegate
    func setCharactersLimitFor(textView: UITextView, range: NSRange, string: String) -> Bool {
        
        // Check charachters limit
        let newText = NSString(string: textView.text).replacingCharacters(in: range, with: string)
        return newText.count < charactersLimit
    }
}
