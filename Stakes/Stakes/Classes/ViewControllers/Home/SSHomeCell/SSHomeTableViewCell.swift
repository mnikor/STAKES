//
//  SSHomeTableViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSHomeTableViewCell: SSBaseTableViewCell {
    
    
    // MARK: Outlets
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var selectGoalButton: SSSelectCircleButton!
    @IBOutlet weak var completeLabel: SSBaseLabel!
    @IBOutlet weak var nameGoalLabel: SSBaseLabel!
    @IBOutlet weak var goalDueDateLabel: SSBaseLabel!
    @IBOutlet weak var stakeNextActionLabel: SSBaseLabel!
    @IBOutlet weak var pointsNextActionLabel: SSBaseLabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editImageView: UIImageView!
    
    
    // MARK: Public funcs
    func configCellBy(_ goal: Goal) {
        
        let textColor = UIColor.colorFrom(colorType: .red)
        let completePercent = goal.calculateСompletion()
        let goalDate = goal.date! as Date
        let goalStake = goal.getStake()
        let goalPoints = goal.getPoints()
        
        // Set color and images
        selectGoalButton.change(type: .goal)
        goalDueDateLabel.textColor = textColor
        stakeNextActionLabel.textColor = textColor
        pointsNextActionLabel.textColor = textColor
        completeLabel.textColor = textColor
        progressSlider.setThumbImage(UIImage(named: "circle@2x"), for: .normal)
        
        // Set values
        nameGoalLabel.text = goal.name
        goalDueDateLabel.text = goalDate.dateWithFormatToString()
        stakeNextActionLabel.text = goalStake.stakeString()
        pointsNextActionLabel.text = "+" + goalPoints.description
        completeLabel.text = completePercent.description + "% Complete"
        progressSlider.value = Float(completePercent)
        selectGoalButton.selectedGoal = goal
        
        // Change size by amount of characters
        nameGoalLabel.sizeByTextFor(lines: 0)
        goalDueDateLabel.sizeByTextFor(lines: 1)
        stakeNextActionLabel.sizeByTextFor(lines: 1)
        pointsNextActionLabel.sizeByTextFor(lines: 1)
        
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
}

