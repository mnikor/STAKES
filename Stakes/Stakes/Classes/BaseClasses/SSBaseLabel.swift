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
    private let colorLabel = UIColor.colorFrom(colorType: .defaultBlack)
    private var fontLabel:UIFont { return UIFont(name: SSConstants.fontType.helvetica.rawValue, size: self.font.pointSize)! }
    
    
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
        setup()
    }
    
    
    // MARK: Private funcs
    private func setup() {
        
        textColor = colorLabel
        font = fontLabel
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    
    // MARK: Public funcs
    
    // Change size by amount of characters
    func sizeByTextFor(lines: Int) {
        numberOfLines = lines
        lineBreakMode = .byTruncatingTail
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.2
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
}
