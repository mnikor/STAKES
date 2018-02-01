//
//  SSNameTextView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 1/4/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSNameTextView: UITextView {
    
    
    // MARK: Public Properties
    var charactersLimit: Int = 46
    var linesLimit: Int = 3 {
        willSet {
            textContainer.maximumNumberOfLines = newValue
        }
    }
    var isEmpty: Bool {
        return text == nil || text == ""
    }
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !isEmpty
        }
    }
    
    
    // MARK: Private Properties
    private var placeholderLabel = UILabel()
    private var fontText:UIFont { return UIFont(name: SSConstants.fontType.helvetica.rawValue, size: self.font!.pointSize)! }
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setPlaceholder()
    }
    
    
    // MARK: Public Funcs
    
    // Set Placeholder text
    func setPlaceholderText(_ text: String) {
        
        placeholderLabel.text = text
    }
    
    // Call for text saving in textViewDidEndEditing func of UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        
        text = textView.text
    }
    
    // Call for limit chars in shouldChangeCharactersIn func of UITextViewDelegate
    func setCharactersLimitFor(textView: UITextView, range: NSRange, string: String) -> Bool {
        
        // Disable return button
        if string == "\n" {
            
            textView.resignFirstResponder()
            endEditing(true)
            return false
        }
        
        // Check charachters limit
        let newText = NSString(string: textView.text).replacingCharacters(in: range, with: string)
        return newText.count < charactersLimit
    }
    
    // Call for hide placeholder in textViewDidBeginEditing func of UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        placeholderLabel.isHidden = true
    }
    
    // MARK: Private funcs
    private func settings() {
        
        isScrollEnabled = false
        sizeToFit()
        textContainer.maximumNumberOfLines = linesLimit
        textContainer.lineBreakMode = .byTruncatingTail
        font = fontText
        autocapitalizationType = .sentences
        textColor = UIColor.colorFrom(colorType: .createActionBlack)
        placeholderLabel.isHidden = !isEmpty
    }
    
    
    // TextView Placeholder
    private func setPlaceholder() {
        
        placeholderLabel.textColor = UIColor.black.withAlphaComponent(0.1)
        placeholderLabel.font = UIFont(name: SSConstants.fontType.helvetica.rawValue, size: 26.0)!
        placeholderLabel.frame = self.bounds
        
        addSubview(placeholderLabel)
    }
}
