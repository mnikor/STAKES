//
//  Action+CoreDataClass.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/17/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Action)
public class Action: NSManagedObject {
    
    
    // MARK: Public properties
    var isPurchased: Bool {
        set {
            self.purchased = newValue
            SSCoreDataManager.instance.saveContext()
        }
        get {
            return self.purchased
        }
    }
    
    
    // MARK: Private properties
    private let points = SSPoint()
    
    
    // MARK: Initializers
    convenience init() {
        self.init(entity: SSCoreDataManager.instance.entityForName(entityName: .action), insertInto: SSCoreDataManager.instance.managedObjectContext)
    }
    
    
    // MARK: Public funcs
    
    // Edit Action Values
    func changeAction(name: String, date: Date, stake: Float) {
        
        self.name = name
        self.date = date as NSDate
        self.stake = stake
        SSCoreDataManager.instance.saveContext()
        
        // Change Action event into Calendar
        SSCalendarSyncManager.editEventFromCalendar(title: name, dueDate: date, eventID: self.event_id)
        
        // Remove old Notification
        SSNotificationsManager.instance.deleteNotification(id: self.id!)
        
        // Add new Notification for Action
        SSNotificationsManager.instance.addNotification(type: .action, name: name, dueDate: date, id: self.id!, stake: stake)
    }
    
    // Change Action Status
    func changeStatus(_ status: GoalStatusType) {
        
        let pointsForCurrentStake = points.calculatePointsFor(stake: self.stake)
        self.status = status.rawValue
        SSCoreDataManager.instance.saveContext()
        
        switch status {
        case .wait, .locked: return
        case .missed:
            
            points.deduct(pointsForCurrentStake)
            
            // Analytics. Capture "Number of missed actions"
            SSAnalyticsManager.logEvent(.missedActions)
            
        case .complete:
            
            var addedPoints = pointsForCurrentStake
            // Accomplished earlier Due Date +2 points
            let actionDate = self.date! as Date
            if actionDate > Date().addCustomDateTime()! {
                
                addedPoints += 2
            }
            
            // Add points to Total Sum
            points.add(addedPoints)
            
            // Add points to goal points
            if goal!.addedPoints != nil {
                goal!.addedPoints! += addedPoints
            } else {
                goal!.addedPoints = addedPoints
            }
            
            // Actions completed count
            let userDefaults = UserDefaults.standard
            let key = SSConstants.keys.kCompletedActions.rawValue
            let countOfShows = userDefaults.integer(forKey: key)
            userDefaults.set(countOfShows + 1, forKey: key)
            
            // Analytics. Capture "Number of completed actions"
            SSAnalyticsManager.logEvent(.completedActions)
        }
        
        // Delete Action Event from Calendar
        SSCalendarSyncManager.deleteEventFromCalendar(eventID: self.event_id)
        
        // Delete Action Notification from Center
        SSNotificationsManager.instance.deleteNotification(id: self.id!)
    }
    
    
    // MARK: Class funcs
    
    // Fetch Action from Core Data
    class func getActionBy(id: String) -> Action? {
        
        let fetchedResultsController = SSCoreDataManager.instance.fetchedResultsController(entityName: .action, keyForSort: "date", predicate: ["id": id])
        do {
            try fetchedResultsController.performFetch()
            let fetchedResults = fetchedResultsController.fetchedObjects
            let fetchedAction = fetchedResults?.first as? Action
            return fetchedAction
        } catch {
            print(error)
        }
        return nil
    }
}
