//
//  SSBaseTextField.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/16/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseTextField: UITextField {
    
    
    // Resizing font when setting text value, depend on Text Field width and characters amount
    override var text: String? {
        didSet {
            self.resizeFont()
        }
    }
    
    
    // MARK: Private Properties
    private var fontText:UIFont { return UIFont(name: SSConstants.fontType.bigCaslon.rawValue, size: self.font!.pointSize)! }
    
    
    // MARK: Public Properties
    let minFontSize: Double = 9.0
    var startFontSize: Double {
        return Double(self.font!.pointSize)
    }
    var isEmpty: Bool {
        return text == nil || text == ""
    }
    
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Overriden funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    
    // MARK: Public funcs
    
    // Call in textFieldShouldReturn func of UITextFieldDelegate
    func shouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        endEditing(true)
        return true
    }
    
    // Addition for Date with format "Month Day th, Year"
    func additionFor(_ dateText: String) -> String {
        
        let dateParts = dateText.components(separatedBy: " ")
        if dateParts.count == 3 {
            return "\(dateParts[0])  \(dateParts[1])th, \(dateParts[2])"
        } else {
            return dateText
        }
    }
    
    
    // MARK: Private funcs
    private func setup() {
        
        font = fontText
        autocapitalizationType = .sentences
    }
    
    // Resizing font depend on Text Field width and characters amount
    private func resizeFont() {
        guard let font = self.font, let text = self.text else { return }
        
        let textBounds = self.textRect(forBounds: self.bounds)
        let maxWidth = textBounds.size.width
        
        for fontSize in stride(from: self.startFontSize, through: self.minFontSize, by: -0.5) {
            let fontSizeCGFloat: CGFloat = CGFloat(fontSize)
            
            let size = (text as NSString).size(withAttributes: [NSAttributedStringKey.font: font.withSize(fontSizeCGFloat)])
            self.font = font.withSize(fontSizeCGFloat)
            if size.width <= maxWidth {
                break
            }
        }
    }
}
