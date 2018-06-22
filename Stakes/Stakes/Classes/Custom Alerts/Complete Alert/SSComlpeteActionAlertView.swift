//
//  SSComlpeteActionAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/12/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import EFCountingLabel

class SSComlpeteActionAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var pointsCountingLabel: EFCountingLabel!
    @IBOutlet weak var contentView: UIView!
    
    
    // MARK: Public properties
    var messageType: SSMessageManager.MessageTypeDescription!
    var action: Action? {
        didSet {
            // Points counting animation
            pointsCountingLabel.isHidden = false
            let points: SSPoint = SSPoint()
            
            let pointsForCurrentStake = points.calculatePointsFor(stake: action!.stake)
            var addedPoints = pointsForCurrentStake
            let actionDate = action!.date! as Date
            if actionDate > Date().addCustomDateTime()! {
                addedPoints += 2
            }
            
            pointsCountingLabel.countFrom(0, to: CGFloat(addedPoints), withDuration: 1.0)
        }
    }
    var goal: Goal? {
        didSet {
            if let currentGoal = goal {
                if action == nil {
                    // Points counting animation
                    pointsCountingLabel.isHidden = false
                    let fromPoints: CGFloat = CGFloat(currentGoal.getPoints())
                    let toPoints: CGFloat = CGFloat(currentGoal.addedPoints ?? currentGoal.getPoints())
                    pointsCountingLabel.countFrom(fromPoints, to: toPoints, withDuration: 1.0)
                }
            }
        }
    }
    
    
    
    // MARK: Initializers
    init(type: SSMessageManager.MessageTypeDescription) {
        super.init(frame: .zero)
        
        self.messageType = type
        self.loadFromNib()
        settingsUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.loadFromNib()
        settingsUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bounds = contentView.bounds
    }
    
    
    // MARK: Actions funcs
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.closeCustomAlert()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        let messageBlackColor = UIColor.fromRGB(rgbValue: 0xA5B0FF)
        
        // Set Labels Text Color
        descriptionLabel.textColor = messageBlackColor
        
        // Settings EFCountingLabel
        pointsCountingLabel.format = "%d"
        pointsCountingLabel.isHidden = true
        pointsCountingLabel.textColor = messageBlackColor
        
        // Set text
        descriptionLabel.text = messageType.rawValue
        
        // Set Image
        var image: UIImage? = UIImage()
        
        switch messageType! {
        case .goalAchieved:
            image = UIImage(named: "goal_achieved")
        case .completedAction, .completedActionNoStake:
            image = UIImage(named: "action_completed")
        default:
            imageView.removeFromSuperview()
            return
        }
        imageView.image = image
    }
}
