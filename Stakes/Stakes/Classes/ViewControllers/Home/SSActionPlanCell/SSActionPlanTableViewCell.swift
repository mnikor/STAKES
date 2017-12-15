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
    @IBOutlet weak var selectButton: SSSelectCircleButton!
    @IBOutlet weak var stakeLabel: SSBaseLabel!
    @IBOutlet weak var dueDateLabel: SSBaseLabel!
    @IBOutlet weak var actionNameLabel: SSBaseLabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var editImageView: UIImageView!
    
    
    // MARK: Public funcs
    func configCellBy(_ action: Action, at indexPath: IndexPath) {
        
        let dueDate = Date.formatter(date: action.date! as Date, with: .monthDayYear)
        
        selectButton.indexPath = indexPath
        hideSelectButton(false)
        
        // Set color
        dueDateLabel.textColor = UIColor.colorFrom(colorType: .dueDate)
        selectButton.change(type: .action)
        
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
    
    
    // MARK: Action funcs
    
    @IBAction func tappedSelectGoalButton(_ sender: SSSelectCircleButton) {
        
        sender.isSelectedView = !sender.isSelectedView
        delegate?.selectCircleButton(sender)
    }
    
    
    // MARK: Private funcs
    private func checkStatus(_ action: Action) {
        
        let status = action.status!
        var textColor = UIColor.fromRGB(rgbValue: 0x64C3FF) //Completed color
        
        switch status {
        case GoalStatusType.complete.rawValue:
            
            statusLabel.text = status
            hideSelectButton(true)
            
        case GoalStatusType.missed.rawValue:
            
            statusLabel.text = status
            hideSelectButton(true)
            textColor = UIColor.fromRGB(rgbValue: 0xFF6464) //Missed color
            
        default:
            statusView.isHidden = true
        }
        statusLabel.textColor = textColor
        pointsLabel.textColor = textColor
        pointsLabel.text = SSPoint().getPointsFor(stake: action.stake)
    }
    
    private func hideSelectButton(_ bool: Bool) {
        
        editImageView.isHidden = bool
        selectButton.isHidden = bool
        statusView.isHidden = !bool
        self.isUserInteractionEnabled = !bool
    }
}
