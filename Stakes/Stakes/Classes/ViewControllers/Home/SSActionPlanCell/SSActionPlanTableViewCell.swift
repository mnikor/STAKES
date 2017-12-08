//
//  SSActionPlanTableViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/28/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSActionPlanTableViewCell: SSBaseTableViewCell {
    
    
    // MARK: Outlets
    @IBOutlet weak var selectButton: SSSelectCircleGoalButton!
    @IBOutlet weak var stakeLabel: SSBaseLabel!
    @IBOutlet weak var dueDateLabel: SSBaseLabel!
    @IBOutlet weak var actionNameLabel: SSBaseLabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    
    
    // MARK: Public funcs
    func configCellBy(_ action: Action, at indexPath: IndexPath) {
        
        selectButton.indexPath = indexPath
        let dueDate = Date.formatter(date: action.date! as Date, with: .monthDayYear)
        
        // Set color
        dueDateLabel.textColor = UIColor.colorFrom(colorType: .dueDate)
        selectButton.backgroundColor = .white
        selectButton.makeBorder(width: .small, color: UIColor.colorFrom(colorType: .defaultBlack))
        
        
        // Set values
        actionNameLabel.text = action.name
        stakeLabel.text = action.stake.stakeString()
        dueDateLabel.text = dueDateLabel.additionFor(dueDate)
        selectButton.selectedAction = action
        
        // Change size by amount of characters
        actionNameLabel.sizeByTextFor(lines: 2)
        
        // Show or Hide statusView
        checkStatus(action)
    }
    
    
    // MARK: Private funcs
    private func checkStatus(_ action: Action) {
        let status = action.status!
        var textColor = UIColor.fromRGB(rgbValue: 0x64C3FF) //Completed color
        
        switch status {
        case GoalStatusType.complete.rawValue:
            statusView.isHidden = false
            statusLabel.text = status
        case GoalStatusType.missed.rawValue:
            statusView.isHidden = false
            statusLabel.text = status
            textColor = UIColor.fromRGB(rgbValue: 0xFF6464) //Missed color
        default:
            break
        }
        statusLabel.textColor = textColor
        pointsLabel.textColor = textColor
        pointsLabel.text = SSPoint().getPointsFor(stake: action.stake)
    }
}
