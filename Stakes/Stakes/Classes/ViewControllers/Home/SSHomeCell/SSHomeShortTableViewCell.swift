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
    @IBOutlet weak var selectGoalButton: SSSelectCircleButton!
    
    
    // MARK: Public funcs
    func configCellBy(_ goal: Goal) {
        
        let goalDate = goal.date! as Date
        let dateText = Date.formatter(date: goalDate, with: .monthDayYear)
        
        // Set color
        goalDateLabel.textColor = UIColor.colorFrom(colorType: .dueDate)
        selectGoalButton.change(type: .action)
        
        goalNameLabel.numberOfLines = 0
        goalNameLabel.lineBreakMode = .byWordWrapping
        
        // Set values
        goalNameLabel.text = goal.name
        goalDateLabel.text = goalDateLabel.additionFor(dateText)
        remainingDaysLabel.text = Date.daysBetween(firstDate: Date(), and: goalDate).description + " Days"
        selectGoalButton.selectedGoal = goal
    }
    
    
    // MARK: Action funcs
    
    @IBAction func tappedSelectGoalButton(_ sender: SSSelectCircleButton) {
        
        sender.isSelectedView = !sender.isSelectedView
        delegate?.selectCircleButton(sender)
    }
}
