//
//  SSCurrentDateLabel.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSCurrentDateLabel: SSBaseLabel {
    
    
    // MARK: Overriden funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        tintColor = .clear
        numberOfLines = 3
        text = additionFor(Date.formatter(date: Date(), with: .weekdayDayMonthYear).localized())
    }
    
    override func additionFor(_ dateText: String) -> String {
        // Example: Friday 19 of January 2018
        
        let dateParts = dateText.components(separatedBy: " ")
        if dateParts.count == 4 {
            return "\(dateParts[0])  \(dateParts[1]) \nof \(dateParts[2]) \n\(dateParts[3])"
        } else {
            return dateText
        }
    }
}
