//
//  SSNotificationsManager.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/18/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import UserNotifications


enum SSReminderType: Double {
    
    case toDay = 0.0
    case oneNight = 43200.0
    case oneDay = 86400.0
    case threeDays = 259200.0
    case week = 604800.0
    case twoWeeks = 1296000.0

    static let reminderTypesArray: [SSReminderType] = [.twoWeeks, .week, .threeDays, .oneDay, oneNight, .toDay]
}


class SSNotificationsManager {
    
    
    //  MARK: Singleton
    static let instance = SSNotificationsManager()
    private init() {}
    
    
    // MARK: Private Properies
    private var reminderType: SSReminderType = .toDay
    
    @available(iOS 10.0, *)
    private var center: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    
    /*
    // TODO: Testing only
    private var currentDayTest: Date?
    private var resultIndex = Double()
    private let dayTimeInterval: Double = 180.0 * 24.0
    */
    
    
    // MARK: Public funcs
    
    // Print all Notifications
    func getAllNotifications() {
        
        if #available(iOS 10.0, *) {
            center.getPendingNotificationRequests { (requests) in
                for requset in requests {
                    print("REQUEST: \(requset)")
                }
                if requests.isEmpty {
                    print("REQUEST not contain")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Delete Notifications by ID
    func deleteNotification(id: String) {
        
        if #available(iOS 10.0, *) {
            
            var notificationIdentifiers = [String]()
            for reminder in SSReminderType.reminderTypesArray {
                
                notificationIdentifiers.append(id + "/" +  reminder.rawValue.description)
            }
            center.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
            print("Delete ID's: \(notificationIdentifiers)")
            getAllNotifications()
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Add Notification for Goal or Action
    func addNotification(type: CoredataObjectType, name: String, dueDate: Date, id: String, stake: Float) {
        
        let selectedDueDate: Date = dueDate.addCustomDateTime()! //create date on due date at 9am
        let timeZone = TimeZone.autoupdatingCurrent
        let secondsFromGMT: TimeInterval = TimeInterval(timeZone.secondsFromGMT())
        let currentDate: Date = Date().addingTimeInterval(secondsFromGMT)
        
        //.addingTimeInterval(7200) //create current date
        for reminder in SSReminderType.reminderTypesArray {
            
            // Check Reminder Settings
            if UserDefaults.standard.bool(forKey: reminder.rawValue.description) {
                
                if reminder == .toDay || reminder == .oneNight {
                    if selectedDueDate.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate < 86400.0 {
                        if reminder == .toDay {
                            if selectedDueDate.compare(currentDate) == ComparisonResult.orderedDescending { //selectedDueDate 9AM > Date()
                                //add notification: today
                                reminderType = reminder
                                let timeInterval = selectedDueDate.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
                                // Make body depend on Reminder Type
                                let body = getNotificationBody(type: type, name: name, stake: stake)
                                
//                                 Make Notification
                                let generatedID = id + "/" +  reminder.rawValue.description
                                makeNotification(type: type, name: name, timeInterval: timeInterval, body: body, id: generatedID)
                            }
                        }
                        if reminder == .oneNight {
                            if selectedDueDate.addingTimeInterval(43200).compare(currentDate) == ComparisonResult.orderedDescending { //selectedDueDate 9PM > Date()
                                //add notification: today
                                reminderType = reminder
                                let timeInterval = selectedDueDate.addingTimeInterval(43200).timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
                                // Make body depend on Reminder Type
                                let body = getNotificationBody(type: type, name: name, stake: stake)
                                
                                // Make Notification
                                let generatedID = id + "/" +  reminder.rawValue.description
                                makeNotification(type: type, name: name, timeInterval: timeInterval, body: body, id: generatedID)
                            }
                        }
                    } else {
                        // Check DueDate for Reminder
                        if let timeInterval = getTimeIntervalFor(selectedDueDate, reminder: reminder) {
                            
                            // Make body depend on Reminder Type
                            let body = getNotificationBody(type: type, name: name, stake: stake)
                            
                            // Make Notification
                            let generatedID = id + "/" +  reminder.rawValue.description
                            makeNotification(type: type, name: name, timeInterval: timeInterval, body: body, id: generatedID)
                        }
                    }
                    
                } else {
                    // Check DueDate for Reminder
                    if let timeInterval = getTimeIntervalFor(selectedDueDate, reminder: reminder) {
                        
                        // Make body depend on Reminder Type
                        let body = getNotificationBody(type: type, name: name, stake: stake)
                        
                        // Make Notification
                        let generatedID = id + "/" +  reminder.rawValue.description
                        makeNotification(type: type, name: name, timeInterval: timeInterval, body: body, id: generatedID)
                    }
                }
            }
        }
        getAllNotifications()
    }
    
    
    // MARK: Private funcs
    
    // Get the nearest reminder date
    private func getTimeIntervalFor(_ dueDate: Date, reminder: SSReminderType) -> TimeInterval? {
        
        let currentDay = Date().addingTimeInterval(7200)
        let timeBeforeDueDate = dueDate.timeIntervalSinceReferenceDate - currentDay.timeIntervalSinceReferenceDate
        
        guard timeBeforeDueDate != 0.0 else { return nil }
        
        reminderType = reminder
        
        if reminder.rawValue < timeBeforeDueDate {
            
            let result = timeBeforeDueDate - reminder.rawValue
            print("Day: \(currentDay). DueDate: \(dueDate). Time: \(result). Type: \(reminder)")
            return result
//                return timeBeforeDueDate - reminder.rawValue
            
            /*
            // TODO: Testing only
            let resultTesting = result / dayTimeInterval
            print("Day: \(currentDay). DueDate: \(dueDate). Time: \(resultTesting). Type: \(reminder)")
            return resultTesting
            */
        }
        return nil
    }
    
    private func getNotificationBody(type: CoredataObjectType, name: String, stake: Float) -> String {
        
        var body = String()
        let object = type.rawValue
        let stakeString = stake.stakeString()
        
        switch reminderType {
        case .oneNight:
            body = "You have not indicated action point as complete. Indicate as complete or change the due date, otherwise your goal will be locked."
        case .toDay:
            body = "You have an action due to be completed today \(name) \nWith a stake of \(stakeString) \nMake sure to complete it to win your stake!"
        case .oneDay:
            body = "You have an action due to be completed tomorrow \(name)"
        default:
            var days = Int()
            switch reminderType {
            case .threeDays: days = 3
            case .week: days = 7
            case .twoWeeks: days = 15
            default: break
            }
            body = "\(days) days until due date for your \(object): \(name) \(stakeString) is at stake. Make sure you complete it!"
        }
        return body
    }
    
    // Make Notification content and add request to Current Notification Center
    private func makeNotification(type: CoredataObjectType, name: String, timeInterval: TimeInterval, body: String, id: String) {
        
        let notificationActionID = SSConstants.keys.kNotificationActionID.rawValue
        let notificationCategoryID = SSConstants.keys.kNotificationCategoryID.rawValue
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            let completeAction = UNNotificationAction(identifier: notificationActionID,
                                                    title: notificationActionID,
                                                    options: [.destructive])
            let category = UNNotificationCategory(identifier: notificationCategoryID,
                                                  actions: [completeAction],
                                                  intentIdentifiers: [],
                                                  options: [])
            center.setNotificationCategories([category])
            
            content.title = type.rawValue
            content.subtitle = name
            content.body = body
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = notificationCategoryID
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false) //timeInterval
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            center.add(request, withCompletionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func removePushNotificationBy(id: String) {
        if #available(iOS 10.0, *) {
            center.getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = []
                for notification:UNNotificationRequest in notificationRequests {
                    if notification.identifier.hasPrefix(id) {
                        identifiers.append(notification.identifier)
                    }
                }
                self.center.removePendingNotificationRequests(withIdentifiers: identifiers)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
