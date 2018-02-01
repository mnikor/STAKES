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
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    
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
        remainingDaysLabel.text = getDaysLabelText(goalDate)
        selectGoalButton.selectedGoal = goal
        
        // Is enable to edit
        isDisableEdit(goal.status == GoalStatusType.complete.rawValue)
    }
    
    
    // MARK: Action funcs
    
    @IBAction func tappedSelectGoalButton(_ sender: SSSelectCircleButton) {
        
        sender.isSelectedView = !sender.isSelectedView
        delegate?.selectCircleButton(sender)
    }
    
    @IBAction func tappedEditButton(_ sender: UIButton) {
        
        delegate?.tappedEditButton!(selectGoalButton.selectedGoal)
    }
    
    // MARK: Private funcs
    private func isDisableEdit(_ bool: Bool) {
        
        editImageView.isHidden = bool
        editButton.isEnabled = !bool
    }
    
    private func getDaysLabelText(_ goalDate: Date) -> String {
        var result = String()
        let days = Date.daysBetween(firstDate: Date(), and: goalDate)
        
        switch days {
        case 0: result = "Today"
        case _ where days < 0:
            
            result = "Missed"
            remainingDaysLabel.textColor = UIColor.colorFrom(colorType: .red)
            
        default: result = days.description + " Days"
        }
        
        return result
    }
}
