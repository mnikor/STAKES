//
//  SSMessageManager.swift
//  Stakes
//
//  Created by Anton Klysa on 4/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import UIKit


class SSMessageManager: NSObject {
    
    enum AlertButtonTitles: String {
        case ok = "Ok"
        case cancel = "Cancel"
    }
    
    enum MessageTypeTitle: String {
        case success = "Success"
        case inProgress = "In progress"
        case warning = "Warning"
        case failure = "Failure"
    }
    
    enum SSCustomAlertType {
        case main, completeAction, withAction, shareGoal
    }
    
    enum MessageTypeDescription: String {
        
        // Simple Messages
        case share = "Share your goal on Facebook or Twitter to earn 10 points!"
        case missedAction = "You have missed your action . Don’t give up, keep going!"
        case goalAchieved = "Fantastic! You have achieved your goal. Congratulations, your get additional points !!!"
        case completedAction = "Congratulations!  You have completed action and earned points. Keep crushing your actions plan!!!"
        case completed = "Congratulations!   You have completed your action, saved your stake and earned points. Keep crushing your actions plan!!!"
        
        // Yes/No options Messages
        case emptyStake = "Add stake to maximise commitment?"
        case lastActionNoSelected = "Would you like to create new actions?"
        case lastAction = "It was your last action, did your  Achieve your goal?"
        case goalDeleted = "Sometimes goals can become irrelevant!  Confirm deletion?"
        case deleteStake = "Looks like you are not confident enough  in your performance.  Confirm deletion?"
        case actionDeleted = "Sometimes actions can become irrelevant! This is probably the case? Confirm deletion?"
        
        // TODO: For Push Notifications (Insert name of the action)
        case calendarReminderToday = "Today is the due date for your action: (name of the action). Make sure you complete it!"
        case calendarReminderOneDay = "Important reminder, that tomorrow is the due date to complete action (name of the action)"
        
        // Warnings
        case dueDateWarning = "You cannot pick any date in the past"
    }
    
    
    // MARK: Properties
    var rootViewController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window?.rootViewController
    }
    
    
    // MARK: Singleton
    static let instance: SSMessageManager = SSMessageManager()
    
    
    // MARK: Class(Static) funcs
    
    // Main Custom Alert
    class func showMainCustomAlertWith(title: MessageTypeTitle, and message: MessageTypeDescription, onViewController: UIViewController?) {
        
        let alertCompletedActionVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .completeActionAlert) as! SSCustomAlertViewController
        
        alertCompletedActionVC.messageType = .main
        alertCompletedActionVC.alertTitle = title.rawValue
        alertCompletedActionVC.alertDescription = message.rawValue
        alertCompletedActionVC.modalPresentationStyle = .overCurrentContext
        
        instance.presentAlert(alertCompletedActionVC, onViewController)
    }
    
    // Custom Alert
    class func showCustomAlertWith(type: SSCustomAlertType, onViewController: UIViewController?) {
        
        let alertCompletedActionVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .completeActionAlert) as! SSCustomAlertViewController
        alertCompletedActionVC.messageType = type
        alertCompletedActionVC.modalPresentationStyle = .overCurrentContext
        
        instance.presentAlert(alertCompletedActionVC, onViewController)
    }
    
    // Custom Alert with Action
    class func showCustomAlertWithAction(title: MessageTypeTitle, and message: MessageTypeDescription, onViewController: UIViewController?, action:@escaping CompletionBlock) {
        
        let alertCompletedActionVC = UIStoryboard.ssInstantiateVC(.home, typeVC: .completeActionAlert) as! SSCustomAlertViewController
        alertCompletedActionVC.messageType = .withAction
        alertCompletedActionVC.alertTitle = title.rawValue
        alertCompletedActionVC.alertDescription = message.rawValue
        alertCompletedActionVC.handler = action
        
        var points = String()
        switch message {
        case .emptyStake: points = ""
        case .lastActionNoSelected: points = "+5"
        case .lastAction: points = "+50"
        case .goalDeleted: points = "-50"
        case .deleteStake: points = "-10"
        case .actionDeleted: points = "-10"
        default: break
        }
        alertCompletedActionVC.points = points
        
        alertCompletedActionVC.modalPresentationStyle = .overCurrentContext
        
        instance.presentAlert(alertCompletedActionVC, onViewController)
    }
    
    // Error Alert
    class func showAlertWith(error: Error, onViewController: UIViewController?) {
        if let viewController = onViewController {
            viewController.present(instance.createAlertWith(title: MessageTypeTitle.failure.rawValue, message: error.localizedDescription, style: .alert), animated: true, completion: nil)
            return
        }
        instance.rootViewController?.present(instance.createAlertWith(title: MessageTypeTitle.failure.rawValue.localized(), message: error.localizedDescription, style: .alert), animated: true, completion: nil)
        return
    }
    
    // Default Alert
    class func showAlertWith(title: MessageTypeTitle, and message: MessageTypeDescription, onViewController: UIViewController?) {
        if onViewController != nil {
            onViewController?.present(instance.createAlertWith(title: title, message: message, style: .alert), animated: true, completion: nil)
            return
        }
        instance.rootViewController?.present(instance.createAlertWith(title: title, message: message, style: .alert), animated: true, completion: nil)
        return
    }
    
    // Alert with Cancel button and action on "Ok" button
    class func showAlertWithCancelButton(title: MessageTypeTitle, message: MessageTypeDescription, onViewController: UIViewController?, action: @escaping ()->()) {
        
        let alert = UIAlertController(title: title.rawValue.localized(), message: message.rawValue.localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertButtonTitles.ok.rawValue.localized(), style: .default) { result in
            action()
        }

        let cancelAction = UIAlertAction(title: AlertButtonTitles.cancel.rawValue.localized(), style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        if onViewController != nil {
            onViewController?.present(alert, animated: true, completion: nil)
            return
        }
        instance.rootViewController?.present(alert, animated: true, completion: nil)
        return
    }
    
    
    // MARK: Private funcs
    private func presentAlert(_ alertVC: UIViewController, _ onViewController: UIViewController?) {
        if let viewController = onViewController {
            viewController.present(alertVC, animated: false, completion: nil)
        } else {
            rootViewController?.present(alertVC, animated: false, completion: nil)
        }
    }
    
    private func createAlertWith(title: MessageTypeTitle, message: MessageTypeDescription, style: UIAlertControllerStyle) -> UIAlertController {
        return createAlertWith(title: title.rawValue, message: message.rawValue, style: style)
    }
    
    private func createAlertWith(title: String, message: String, style: UIAlertControllerStyle) -> UIAlertController {
        
        let alert = UIAlertController(title: title.localized(), message: message.localized(), preferredStyle: style)
        let cancelAction = UIAlertAction(title: AlertButtonTitles.ok.rawValue.localized(), style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancelAction)
        return alert
    }
}
