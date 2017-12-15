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
    @IBOutlet weak var nameNextActionLabel: SSBaseLabel!
    @IBOutlet weak var stakeNextActionLabel: SSBaseLabel!
    @IBOutlet weak var pointsNextActionLabel: SSBaseLabel!
    
    
    // MARK: Public funcs
    func configCellBy(_ goal: Goal) {
        
        let point = SSPoint()
        let textColor = UIColor.colorFrom(colorType: .red)
        let completePercent = goal.calculateСompletion()
        
        // Set color and images
        selectGoalButton.change(type: .goal)
        nameNextActionLabel.textColor = textColor
        stakeNextActionLabel.textColor = textColor
        pointsNextActionLabel.textColor = textColor
        completeLabel.textColor = textColor
        progressSlider.setThumbImage(UIImage(named: "circle@2x"), for: .normal)
        
        // Set values
        var name: String?
        var points = String()
        var stake = String()
        
        if let nextAction = goal.getActions().first {
            name = nextAction.name
            stake += nextAction.stake.stakeString()
            points = point.getPointsFor(stake: nextAction.stake)
        } else {
            name = ""
            stake = ""
            points = ""
        }
        
        nameGoalLabel.text = goal.name
        nameNextActionLabel.text = name
        stakeNextActionLabel.text = stake
        pointsNextActionLabel.text = points
        
        completeLabel.text = completePercent.description + "% Complete"
        progressSlider.value = Float(completePercent)
        selectGoalButton.selectedGoal = goal
        
        // Change size by amount of characters
        nameGoalLabel.sizeByTextFor(lines: 0)
        nameNextActionLabel.sizeByTextFor(lines: 2)
        stakeNextActionLabel.sizeByTextFor(lines: 1)
        pointsNextActionLabel.sizeByTextFor(lines: 1)
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedSelectGoalButton(_ sender: SSSelectCircleButton) {
        
        sender.isSelectedView = !sender.isSelectedView
        delegate?.selectCircleButton(sender)
    }
}

