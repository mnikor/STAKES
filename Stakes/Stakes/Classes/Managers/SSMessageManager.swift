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
        case feedback = "Do you find The Bold app helpful?"
        case newFeatures = "We are introducing 2 cool new features: \n1. Lessons of Powerful Knowledge, and \n2. Levels of Mastery"
        case missedAction = "You've missed your action. Don’t give up, keep going!"
        case goalAchieved = "Fantastic! \nYou have achieved your goal. \nCongratulations, you get additional points!!!"
        case completedActionNoStake = "Congratulations! \nYou have completed your action and earned points. Keep crushing your action plan!!!"
        case completedAction = "Congratulations! \nYou have completed your action, saved your stake and earned points. Keep crushing your action plan!!!"
        case firstPointsEarned = "Keep earning points to unlock Lessons and progress with Mastery Levels"
        case inAppPurchasesWarning = "If you miss to complete action point your goal will be locked. To unlock it stake should be paid as in-app purchase"
        case unlockLesson = "Unlock Lessons  to acquire powerful \nknowledge quicker."
        
        case knowledge = "Acquire important knowledge about how to progress quicker and smarter towards your goals. These lessons are based on scientific research, the experience of high performance people in many fields, and the invaluable knowledge of many great books. \n\nEarn 30 points and spend one month working on your goal"
        case levelsInfo = "Progress on levels to  master  a skill\n of achieving any goal any time.\nBecome a grandmaster of your life!"
        // "masteryLevel" firts part here, second part will add with current level title in VC
        case masteryLevel = "Incredible,\nyou just moved to another Level \nof Mastery! Now you are "
        case purchaseDone = "Thank you for purchase! \nWe sincereley hope this lesson(s) \nwill be helpful for you."
        case unlockedLesson = "Amazing, \nyou just unlocked a new \nLesson of Powerful Knowledge! \nRead it carefully and apply what you learn!"
        
        // Yes/No options Messages
        case emptyStake = "Add stake to maximise commitment?"
        case lastActionNoSelected = "Would you like to create a new action?"
        case lastAction = "This was your last action, have you Achieved your goal?"
        case goalDeleted = "Sometimes goals become irrelevant! \nConfirm deletion (-50 points):"
        case deleteStake = "Are you sure you want to delete this stake? \nConfirm deletion (-10 points):"
        case actionDeleted = "Sometimes actions become irrelevant \nas we adapt our strategy! \nConfirm deletion (-10 points):"
        case unLockGoal = "You’ve missed your action. \nYour goal is locked now. To unlock  it stake should be paid as in-app purchase. \nDon’t give up, keep going!"
        
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
    
    // For simple alert with text and goal if needed
    class func showCustomAlertWith(message: MessageTypeDescription, goal: Goal? = nil, action: Action? = nil, onViewController: UIViewController?) {
        
        let alertCompletedActionVC = SSCustomAlertViewController.instantiate(.home) as! SSCustomAlertViewController
        alertCompletedActionVC.messageType = message
        alertCompletedActionVC.goal = goal
        alertCompletedActionVC.action = action
        
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
