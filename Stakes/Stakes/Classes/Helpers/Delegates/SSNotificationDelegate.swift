//
//  SSNotificationDelegate.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/20/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import UserNotifications


class SSNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    
    // MARK: UNUserNotificationCenterDelegate
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let request = response.notification.request
        let actionID = request.identifier.components(separatedBy: "/").first!
        let action = Action.getActionBy(id: actionID)
        
        // Handle tapped Complete Button
        switch response.actionIdentifier {
            
        // Notification was dismissed by user
        case UNNotificationDismissActionIdentifier:
            
            completionHandler()
            
        // App was opened from notification (tapped View, Open buttons)
        case UNNotificationDefaultActionIdentifier:
            
            completionHandler()
            
        // Tapped Complete Action button
        case SSConstants.keys.kNotificationActionID.rawValue:
            
            // Complete Action here
            if let notifyAction = action {
                
                if notifyAction.status == GoalStatusType.wait.rawValue {
                    notifyAction.changeStatus(.complete)
                    SSMessageManager.showCustomAlertWith(message: .completedAction, goal: notifyAction.goal, onViewController: nil)
                }
                
            } else {
                SSMessageManager.showAlertWith(title: .failure, and: .failSaveStatusAction, onViewController: nil)
            }
            
            completionHandler()
        default:
            
            completionHandler()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
}
