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
    
    enum AlertButtonTitle: String {
        case ok = "Ok"
        case cancel = "Cancel"
    }
    
    enum MessageTitle: String {
        case success = "Success!"
        case inProgress = "In progress"
        case warning = "Warning!"
        case failure = "Failure!"
        case error = "Error"
        case noTitle = ""
    }
    
    enum MessageTypeDescription: String {
        
        // Simple Messages
        case share = "Share your goal with friends"
        case missedAction = "You have missed your action. Don’t give up, keep going!"
        case goalAchieved = "Fantastic! You have achieved your goal. Congratulations, you get additional points !!!"
        case completedActionNoStake = "You have completed action and earned points."
        case completedAction = "You have completed your action,\nsaved your stake and earned points."
        case firstPointsEarned = "Keep earning points to use it in our next app updates!"
        case inAppPurchasesWarning = "If you miss to complete action point your goal will be locked. To unlock it stake should be paid as in-app purchase"
        
        // Yes/No options Messages
        case emptyStake = "Add stake to maximise commitment. Continue without stake?"
        case lastActionNoSelected = "Would you like to create new actions?"
        case lastAction = "It was your last action, did your  Achieve your goal?"
        case goalDeleted = "Sometimes goals can become irrelevant!  Confirm deletion?"
        case deleteStake = "Looks like you are not confident enough  in your performance.  Confirm stake deletion?"
        case actionDeleted = "Sometimes actions can become irrelevant and we adapt strategy! Confirm deletion?"
        case unLockGoal = "You missed to complete the action point. Please pay the stake in a form of in-app purchase to unlock your goal."
        
        // Warnings
        case dueDateWarning = "You cannot pick any date in the past"
        
        // Error
        case failSaveStatusAction = "Something went wrong. Can't save Action status"
        case error = "Something went wrong. Try again later"
        case goalIsAchieved = "Goal has been achieved!"
    }
    
    
    // MARK: Properties
    static let instance = SSMessageManager()
    var rootViewController: UIViewController? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window?.rootViewController
    }
    
    
    // MARK: Custom Alerts. Class(Static) funcs
    
    // For simple alert with text
    class func showCustomAlertWith(message: MessageTypeDescription, onViewController: UIViewController?) {
        
        let alertCompletedActionVC = SSCustomAlertViewController.instantiate(.home) as! SSCustomAlertViewController
        alertCompletedActionVC.messageType = message
        
        instance.presentAlert(alertCompletedActionVC, onViewController)
    }
    
    // For Alert with Yes/No options
    class func showCustomAlertWithAction(message: MessageTypeDescription, onViewController: UIViewController?, action:@escaping CompletionBlock) {
        
        let alertCompletedActionVC = SSCustomAlertViewController.instantiate(.home) as! SSCustomAlertViewController
        alertCompletedActionVC.messageType = message
        alertCompletedActionVC.handler = action
        
        instance.presentAlert(alertCompletedActionVC, onViewController)
    }
    
    // For Last Action Alert
    class func showLastActionCustomAlert(message: MessageTypeDescription, with goal: Goal, onViewController: UIViewController?, action:@escaping CompletionBlock) {
        
        let alertCompletedActionVC = SSCustomAlertViewController.instantiate(.home) as! SSCustomAlertViewController
        alertCompletedActionVC.messageType = message
        alertCompletedActionVC.handler = action
        alertCompletedActionVC.goal = goal
        
        instance.presentAlert(alertCompletedActionVC, onViewController)
    }
    
    
    // MARK: Native Alerts. Class(Static) funcs
    
    // Error Alert
    class func showAlertWith(error: Error, onViewController: UIViewController?) {
        if let viewController = onViewController {
            viewController.present(instance.createAlertWith(title: MessageTitle.error.rawValue, message: error.localizedDescription, style: .alert), animated: true, completion: nil)
            return
        }
        instance.rootViewController?.present(instance.createAlertWith(title: MessageTitle.error.rawValue.localized(), message: error.localizedDescription, style: .alert), animated: true, completion: nil)
        return
    }
    
    // Default Alert
    class func showAlertWith(title: MessageTitle, and message: MessageTypeDescription, onViewController: UIViewController?) {
        if onViewController != nil {
            onViewController?.present(instance.createAlertWith(title: title, message: message, style: .alert), animated: true, completion: nil)
            return
        }
        instance.rootViewController?.present(instance.createAlertWith(title: title, message: message, style: .alert), animated: true, completion: nil)
        return
    }
    
    // Alert with Cancel button and action on "Ok" button
    class func showAlertWithCancelButton(title: MessageTitle, message: MessageTypeDescription, onViewController: UIViewController?, action: @escaping ()->()) {
        
        let alert = UIAlertController(title: title.rawValue.localized(), message: message.rawValue.localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertButtonTitle.ok.rawValue.localized(), style: .default) { result in
            action()
        }

        let cancelAction = UIAlertAction(title: AlertButtonTitle.cancel.rawValue.localized(), style: .cancel, handler: { (action) in
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
        
        alertVC.modalPresentationStyle = .overCurrentContext
        
        if let viewController = onViewController {
            viewController.present(alertVC, animated: false, completion: nil)
        } else {
            rootViewController?.present(alertVC, animated: false, completion: nil)
        }
    }
    
    private func createAlertWith(title: MessageTitle, message: MessageTypeDescription, style: UIAlertControllerStyle) -> UIAlertController {
        return createAlertWith(title: title.rawValue, message: message.rawValue, style: style)
    }
    
    private func createAlertWith(title: String, message: String, style: UIAlertControllerStyle) -> UIAlertController {
        
        let alert = UIAlertController(title: title.localized(), message: message.localized(), preferredStyle: style)
        let cancelAction = UIAlertAction(title: AlertButtonTitle.ok.rawValue.localized(), style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(cancelAction)
        return alert
    }
}
