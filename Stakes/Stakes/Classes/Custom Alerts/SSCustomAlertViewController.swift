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
    
    
    // MARK: Private Properties
    private var messageView = SSBaseCustomAlertView()
    private var alertText: String {
        return messageType.rawValue
    }
    private var points: String {
        
        switch messageType {
        case .emptyStake: return ""
        case .share: return "+10"
        case .lastAction: return "+50"
        case .goalDeleted: return "-50"
        case .deleteStake: return "-10"
        case .actionDeleted: return "-10"
        case .lastActionNoSelected: return "+5"
        default: return ""
        }
    }
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define Alert Type
        switch messageType {
        case .completedAction, .completedActionNoStake:
            
            let completedActionAlert = SSComlpeteActionAlertView()
            completedActionAlert.descriptionLabel.text = alertText
            messageView = completedActionAlert
            
        case .goalAchieved, .firstPointsEarned, .inAppPurchasesWarning, .missedAction:
            
            let mainCustomAlert = SSMainCustomAlertView()
            mainCustomAlert.descriptionLabel.text = alertText
            messageView = mainCustomAlert
            
        case .emptyStake, .deleteStake, .goalDeleted, .actionDeleted:
            
            let emptyStakeAlert = SSActionAlertView()
            emptyStakeAlert.descriptionLabel.text = alertText
            emptyStakeAlert.pointsLabel.text = points
            emptyStakeAlert.starImageView.isHidden = points == ""
            messageView = emptyStakeAlert
            
        case .lastAction:
            
            let lastActionAlert = SSLastActionAlertView()
            lastActionAlert.goal = goal
            messageView = lastActionAlert
        case .unLockGoal:
            
            let purchaseAlert = SSPurchaseAlertView()
            purchaseAlert.goal = goal
            purchaseAlert.descriptionLabel.text = alertText
            messageView = purchaseAlert
            
        default: break
        }
        
        messageView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createMessageView()
    }
    
    
    // MARK: Private funcs
    private func createMessageView() {
        
        // TODO: Adaptive View Size
        let height: CGFloat = 157.0
        let width: CGFloat = 294.0
        let cornerRadius: CGFloat = 8.0
        
        view.addSubview(messageView)
        
        // MessageView settings
        messageView.makeBorder(width: .small, color: UIColor.colorFrom(colorType: .red))
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

