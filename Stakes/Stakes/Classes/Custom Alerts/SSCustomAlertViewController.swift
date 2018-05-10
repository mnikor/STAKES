//
//  SSCustomAlertViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/12/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

typealias CompletionBlock = () -> ()

class SSCustomAlertViewController: UIViewController {
    
    
    // MARK: Public Properties
    var messageType: SSMessageManager.MessageTypeDescription = .share
    var handler: CompletionBlock?
    var goal: Goal?
    var action: Action?
    
    
    // MARK: Private Properties
    private var alertViewBorderColor: UIColor = UIColor.colorFrom(colorType: .red)
    private var alertText: String {
        return messageType.rawValue
    }
    private var points: String {
        
        switch messageType {
        case .emptyStake: return ""
        case .share: return "+10"
        case .lastAction: return "+50"
        case .goalAchieved: return "+50"
        case .deleteStake: return "-10"
        case .lastActionNoSelected: return "+5"
//        case .goalDeleted: return "-50"
//        case .actionDeleted: return "-10"
        default: return ""
        }
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define Alert View Type
        let messageView = getMessageView(messageType: messageType)
        
        // Add Alert View to Controller
        addMessageView(messageView: messageView)
    }
    
    
    // MARK: Private funcs
    
    // Get Alert View depend on type
    private func getMessageView(messageType: SSMessageManager.MessageTypeDescription) -> SSBaseCustomAlertView {
        
        var messageView: SSBaseCustomAlertView = SSBaseCustomAlertView()
        
        switch messageType {
        case .completedAction, .completedActionNoStake, .goalAchieved:
            
            let completedActionAlert = SSComlpeteActionAlertView(type: messageType)
            completedActionAlert.goal = goal
            if action != nil {
                completedActionAlert.action = action
            }
            messageView = completedActionAlert
            
        case .firstPointsEarned, .inAppPurchasesWarning, .missedAction, .newFeatures:
            
            messageView = SSMainCustomAlertView(type: messageType)
            
        case .knowledge, .masteryLevel, .levelsInfo , .purchaseDone, .unlockedLesson:
            
            messageView = SSMainCustomAlertView(type: messageType)
            alertViewBorderColor = UIColor.lightGray
            
        case .emptyStake, .deleteStake, .goalDeleted, .actionDeleted:
            
            let withActionAlertView = SSActionAlertView(type: messageType)
            withActionAlertView.pointsLabel.text = points
            withActionAlertView.starImageView.isHidden = points == ""
            messageView = withActionAlertView
            
        case .lastAction:
            
            let lastActionAlert = SSLastActionAlertView()
            lastActionAlert.goal = goal
            messageView = lastActionAlert
            
        case .unLockGoal:
            
            let purchaseAlert = SSPurchaseAlertView()
            purchaseAlert.goal = goal
            purchaseAlert.descriptionLabel.text = alertText
            messageView = purchaseAlert
        
        case .feedback:
            
            messageView = SSFeedbackAlertView()
            
        case .unlockLesson:
            
            messageView = SSUnlockLessonsAlertView()
            alertViewBorderColor = UIColor.lightGray
            
        default:
            
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
            break
        }
        
        return messageView
    }
    
    private func addMessageView(messageView: SSBaseCustomAlertView) {
        
        let height: CGFloat = messageView.frame.height
        let width: CGFloat = self.view.frame.width - 30
        let cornerRadius: CGFloat = 8.0
        
        view.addSubview(messageView)
        messageView.delegate = self
        
        // MessageView settings
        messageView.makeBorder(width: .small, color: alertViewBorderColor)
        messageView.layer.cornerRadius = cornerRadius
        messageView.backgroundColor = .white
        
        // Set constraints
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        messageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        messageView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}


// MARK: SSCustomAlertActionDelegate
extension SSCustomAlertViewController: SSCustomAlertActionDelegate {

    func closeCustomAlert() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func actionCustomAlert() {
        
        handler!()
        closeCustomAlert()
    }
}

