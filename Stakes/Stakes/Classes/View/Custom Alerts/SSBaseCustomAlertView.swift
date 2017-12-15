//
//  SSBaseCustomAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit


protocol SSCustomAlertActionDelegate {
    
    // Required func
    func closeCustomAlert()
    
    // Optional func
    func actionCustomAlert(actionType: SSCustomAlertActionType)
}


enum SSCustomAlertActionType {
    
    case deletingActionYes
    case shareFB
    case shareGoogle
    case shareTwitter
}


class SSBaseCustomAlertView: UIView {
    
    
    // MARK: Delegate
    var delegate: SSCustomAlertActionDelegate?
}


extension SSCustomAlertActionDelegate {
    
    func actionCustomAlert(actionType: SSCustomAlertActionType) {
        
    }
}
