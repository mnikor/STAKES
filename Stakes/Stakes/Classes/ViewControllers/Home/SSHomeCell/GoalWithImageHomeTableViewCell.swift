//
//  GoalWithImageHomeTableViewCell.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 2/22/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class GoalWithImageHomeTableViewCell: SSBaseTableViewCell {
    
    
    // MARK: Outlets
    
    // Labels
    @IBOutlet weak var completeLabel: SSBaseLabel!
    @IBOutlet weak var nameGoalLabel: SSBaseLabel!
    @IBOutlet weak var goalDueDateLabel: SSBaseLabel!
    @IBOutlet weak var stakeNextActionLabel: SSBaseLabel!
    @IBOutlet weak var pointsNextActionLabel: SSBaseLabel!
    
    // Views
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var adaptiveContentView: UIView!
    
    // Buttons
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var selectGoalButton: SSSelectCircleButton!
    
    // Constraints
    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideImageConstraint: NSLayoutConstraint!
    
    
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
        updateCellForImage(goal.getImage())
        goalDueDateLabel.text = goalDate.dateWithFormatToString()
        stakeNextActionLabel.text = goalStake.stakeString()
        pointsNextActionLabel.text = "+" + goalPoints.description
        completeLabel.text = completePercent.description + "% Complete"
        progressSlider.value = Float(completePercent)
        selectGoalButton.selectedGoal = goal
        
        // Change size by amount of characters
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
    
    private func updateCellForImage(_ image: UIImage?) {
        
        if let goalImage = image {
            
            // Goal has image
            goalImageView.isHidden = false
            nameLabelHeightConstraint.constant = 40.0
            hideImageConstraint.constant = 185.0
            goalImageView.image = goalImage
            nameGoalLabel.sizeByTextFor(lines: 2)
            
            // GoalImageView settings
            goalImageView.layer.masksToBounds = true
            goalImageView.layer.cornerRadius = 10.0
            goalImageView.makeBorder(width: .small, color: UIColor.lightGray)
            
        } else {
            
            // Goal without Image
            goalImageView.isHidden = true
            nameLabelHeightConstraint.constant = 140.0
            hideImageConstraint.constant = 5.0
            nameGoalLabel.sizeByTextFor(lines: 0)
        }
        layoutIfNeeded()
    }
}
