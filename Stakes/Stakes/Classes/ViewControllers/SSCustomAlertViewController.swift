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
    var messageView = SSBaseCustomAlertView()
    var messageType: SSMessageManager.SSCustomAlertType = .main
    var handler: CompletionBlock?
    var alertTitle: String?
    var alertDescription: String?
    var points: String?
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch messageType {
        case .main:
            
            let mainAlertView = SSMainCustomAlertView()
            mainAlertView.titleLabel.text = alertTitle
            mainAlertView.descriptionLabel.text = alertDescription
            messageView = mainAlertView
            
        case .withAction:
            
            let withActionAlertView = SSActionAlertView()
            withActionAlertView.titleLabel.text = alertTitle
            withActionAlertView.descriptionLabel.text = alertDescription
            withActionAlertView.pointsLabel.text = points
            withActionAlertView.starImageView.isHidden = points == ""
            messageView = withActionAlertView
            
        case .completeAction: messageView = SSComlpeteActionAlertView()
        case .shareGoal: messageView = SSShareGoalAlertView()
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
        let height: CGFloat = 190.0
        let width: CGFloat = 294.0
        let cornerRadius: CGFloat = 8.0
        
        view.addSubview(messageView)
        
        // MessageView settings
        messageView.makeBorder(width: .small, color: UIColor.colorFrom(colorType: .red))
        messageView.layer.cornerRadius = cornerRadius
        messageView.backgroundColor = .white
        
        // Set constraints
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        messageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        messageView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}

extension SSCustomAlertViewController: SSCustomAlertActionDelegate {

    func closeCustomAlert() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func actionCustomAlert(actionType: SSCustomAlertActionType) {
        
        switch actionType {
        case .deletingActionYes: handler!()
        case .shareFB: print("Share FB")
        case .shareTwitter: print("Share Twitter")
        case .shareGoogle: print("Share Google")
        }   
        
        closeCustomAlert()
    }
}

