//
//  Goal+CoreDataClass.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/17/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//
//

import Foundation
import CoreData


enum GoalStatusType: String {
    case wait = "wait"
    case complete = "Completed"
    case missed = "Missed"
    case locked = "Locked"
}


@objc(Goal)
public class Goal: NSManagedObject {
    
    
    // MARK: Private properties
    private let points = SSPoint()
    
    
    // MARK: Initializers
    convenience init() {
        self.init(entity: SSCoreDataManager.instance.entityForName(entityName: .goal), insertInto: SSCoreDataManager.instance.managedObjectContext)
    }
    
    
    // MARK: Public funcs
    
    // Create new Action for current Goal and Save Context
    func createAction(name: String, date: Date, stake: Float?) -> Action {
        
        let newAction = Action()
        let actionID = UUID().uuidString
        
        newAction.goal = self
        newAction.name = name
        newAction.date = date as NSDate
        newAction.stake = stake ?? 0.0
        newAction.status = GoalStatusType.wait.rawValue
        newAction.id = actionID
        self.addToActions(newAction)
        SSCoreDataManager.instance.saveContext()
        
        // Analytics. Capture "all Actions", "all Stakes", "overall Stakes amount"
        SSAnalyticsManager.logEvent(.allActions, with: ["Stake" : newAction.stake.round(2)])
        
        // Save Action Event to Calendar
        SSCalendarSyncManager.addEventToCalendar(title: name, dueDate: date) { (eventId) in
            
            if let id = eventId {
                
                let action = Action.getActionBy(id: actionID)
                action?.event_id = id
                SSCoreDataManager.instance.saveContext()
            }
        }
        
        // Add Notification for Action
        SSNotificationsManager.instance.addNotification(type: .action, name: name, dueDate: date, id: actionID, stake: newAction.stake)
        
        return newAction
    }
    
    // Set properties for current Goal and Save Context
    func make(name: String, date: Date) {
        let goalID = UUID().uuidString
        
        self.name = name
        self.date = date as NSDate
        self.stake = 0.0
        self.id = goalID
        SSCoreDataManager.instance.saveContext()
        
        // Analytics. Capture "Number of Goals set overall". "Average number of goals per user"
        SSAnalyticsManager.logEvent(.allGoals)
        
        // Save Goal Event to Calendar
        SSCalendarSyncManager.addEventToCalendar(title: name, dueDate: date) { (eventId) in
            
            if let id = eventId {
                
                let goal = Goal.getGoalBy(id: goalID)
                goal?.event_id = id
                SSCoreDataManager.instance.saveContext()
            }
        }
    }
    
    // Edit Goal Values
    func changeGoal(name: String, date: Date) {
        
        self.name = name
        self.date = date as NSDate
        SSCoreDataManager.instance.saveContext()
        
        // Change Goal Event into Calendar
        SSCalendarSyncManager.editEventFromCalendar(title: name, dueDate: date, eventID: self.event_id)
    }
    
    // Get Action array sorted by Date and Status for current Goal
    func getActionsSortByStatus() -> [Action] {
        var result = [Action]()
        
        if let array = self.actions?.array as? [Action] {
            
            // Filter and sort by date only waiting action
            let sortByStatusArray = array.filter({ $0.status == GoalStatusType.wait.rawValue })
            var sortByDateArray = sortByStatusArray.sorted(by: { $0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970 })
            
            // Filter other action
            let sortByOtherStatusArray = array.filter({
                
                $0.status == GoalStatusType.complete.rawValue ||
                $0.status == GoalStatusType.missed.rawValue
            })
            
            sortByDateArray.append(contentsOf: sortByOtherStatusArray)
            
            result = sortByDateArray
        }
        return result
    }
    
    // Get Actions array sorted by Date for current Goal
    func getActions() -> [Action] {
        var result = [Action]()
        
        if let array = self.actions?.array as? [Action] {
            
            let sortedActionsArray = array.sorted(by: { $0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970 })
            result = sortedActionsArray
        }
        return result
    }
    
    // Get filtered Actions array
    func getActionsBy(statusFilters: [GoalStatusType]) -> [Action] {
        
        for filter in statusFilters {
            
            return getActions().filter({ action in
                
                action.status! == filter.rawValue
            })
        }
        
        return [Action]()
    }
    
    // Get Stake for Goal
    func getStake() -> Float {
        
        var result = Float()
        let filteredArray = getActionsBy(statusFilters: [.wait])
        
        for action in filteredArray {
            result += action.stake
        }
        
        return result
    }
    
    // Get Points for Goal
    func getPoints() -> Int {
        
        var result = Int()
        
        let filteredArray = getActionsBy(statusFilters: [.wait])
        
        for action in filteredArray {
            result += points.calculatePointsFor(stake: action.stake)
        }
        
        return result
    }
    
    // Delete Action from Goal and Save Context
    func delete(_ action: Action) {
        
        // Delete Action Event from Calendar
        SSCalendarSyncManager.deleteEventFromCalendar(eventID: action.event_id)
        
        // Delete Action Notification from Center
        SSNotificationsManager.instance.deleteNotification(id: action.id!)
        
        let managedObject = action as NSManagedObject
        SSCoreDataManager.instance.managedObjectContext.delete(managedObject)
        SSCoreDataManager.instance.saveContext()
        
        // Analytics. Capture "Number of actions deleted"
        SSAnalyticsManager.logEvent(.deletedActions)
    }
    
    // Delete Goal and Save Context
    func deleteGoal() {
        
        // Delete Goal Event from Calendar
        SSCalendarSyncManager.deleteEventFromCalendar(eventID: self.event_id)
        
        // Delete Action Events from Calendar
        for action in getActions() {
            
            SSNotificationsManager.instance.deleteNotification(id: action.id!)
            SSCalendarSyncManager.deleteEventFromCalendar(eventID: action.event_id)
        }
        
        let managedObject = self as NSManagedObject
        SSCoreDataManager.instance.managedObjectContext.delete(managedObject)
        SSCoreDataManager.instance.saveContext()
        
        // Analytics. Capture "Number of goals deleted"
        SSAnalyticsManager.logEvent(.deletedGoals)
    }
    
    // Calculate percent of completed action
    func calculateСompletion() -> Int {
        
        let actions = self.getActions()
        if actions.count == 0 {
            return 0
        } else {
            let completeStatusAction = actions.filter { $0.status == GoalStatusType.complete.rawValue }
            
            let actionsCount: Float = Float(actions.count)
            let result: Float = Float(completeStatusAction.count) / actionsCount
            
            return Int(result * 100.0)
        }
    }
    
    // Change Goal Status
    func changeStatus(_ status: GoalStatusType) {
        
        self.status = status.rawValue
        SSCoreDataManager.instance.saveContext()
        
        switch status {
        case .wait:
            
            for action in getActionsBy(statusFilters: [.locked]) {
                action.changeStatus(status)
            }
            return
            
        case .locked:
            
            for action in getActionsBy(statusFilters: [.wait]) {
                action.changeStatus(status)
            }
            return
            
        case .complete:
            
            points.add(50)
            
            // Analytics. Capture "Number of achieved goals"
            SSAnalyticsManager.logEvent(.achievedGoals)
            
        case .missed: break
        }
        
        for action in getActions() {
            
            action.changeStatus(status)
        }
        
        // Delete Goal Event from Calendar
        SSCalendarSyncManager.deleteEventFromCalendar(eventID: self.event_id)
    }
    
    // Get NSFetchedResultsController with Action for current Goal
    func getActionsOf() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoredataObjectType.action.rawValue)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "%K == %@", "goal", self)
        fetchRequest.predicate = predicate
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: SSCoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    // Check missed Actions
    func checkMissedActions() -> Bool {
        
        var isMissedAction = false
        for action in self.getActionsBy(statusFilters: [.wait, .locked]) {
            
            let actionDueDate = action.date! as Date
            if actionDueDate < Date().addCustomDateTime()! {
                
                action.changeStatus(.missed)
                isMissedAction = true
            }
        }
        return isMissedAction
    }
    
    func getActionsForPurchase() -> [Action] {
        
        var actions = [Action]()
        for action in self.getActionsBy(statusFilters: [.missed]) {
            
            if action.stake != 0 && action.purchased == false {
                actions.append(action)
            }
        }
        print("Actions for PURCHASE: \(actions)")
        return actions
    }
    
    
    // Fetch Action from Core Data
    class func getGoalBy(id: String) -> Goal? {
        
        let fetchedResultsController = SSCoreDataManager.instance.fetchedResultsController(entityName: .goal, keyForSort: "date", predicate: ["id": id])
        do {
            try fetchedResultsController.performFetch()
            let fetchedResults = fetchedResultsController.fetchedObjects
            let fetchedAction = fetchedResults?.first as! Goal
            return fetchedAction
        } catch {
            print(error)
        }
        return nil
    }
}
