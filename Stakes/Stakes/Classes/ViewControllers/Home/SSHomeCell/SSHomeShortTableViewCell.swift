//
//  SSHomeShortTableViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSHomeShortTableViewCell: SSBaseTableViewCell {
    
    
    // MARK: Outlets
    @IBOutlet weak var goalNameLabel: SSBaseLabel!
    @IBOutlet weak var goalDateLabel: SSBaseLabel!
    @IBOutlet weak var remainingDaysLabel: SSBaseLabel!
    @IBOutlet weak var deleteCompleteButton: SSSelectCircleGoalButton!
    
    
    // MARK: Public funcs
    func configCellBy(_ goal: Goal) {
        
        let goalDate = goal.date! as Date
        let dateText = Date.formatter(date: goalDate, with: .monthDayYear)
        
        // Set color
        goalDateLabel.textColor = UIColor.colorFrom(colorType: .dueDate)
        deleteCompleteButton.backgroundColor = .white
        deleteCompleteButton.makeBorder(width: .small, color: UIColor.colorFrom(colorType: .defaultBlack))
        
        // Change size by amount of characters
        goalNameLabel.sizeByTextFor(lines: 2)
        
        // Set values
        goalNameLabel.text = goal.name
        goalDateLabel.text = goalDateLabel.additionFor(dateText)
        remainingDaysLabel.text = Date.daysBetween(firstDate: Date(), and: goalDate).description + " Days"
        deleteCompleteButton.selectedGoal = goal
    }
}
