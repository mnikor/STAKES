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
    case missed = "missed"
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
        
        newAction.goal = self
        newAction.name = name
        newAction.date = date as NSDate
        newAction.stake = stake ?? 0.0
        newAction.status = GoalStatusType.wait.rawValue
        
        self.addToActions(newAction)
        SSCoreDataManager.instance.saveContext()
        
        return newAction
    }
    
    // Set properties for current Goal and Save Context
    func make(name: String, date: Date) {
        
        self.name = name
        self.date = date as NSDate
        self.stake = 0.0
        
        SSCoreDataManager.instance.saveContext()
    }
    
    // Get Action array sorted by Date for current Goal
    func getActions() -> [Action] {
        var result = [Action]()
        
        if let array = self.actions?.array as? [Action] {
            
            let sortedActionsArray = array.sorted(by: { $0.date!.timeIntervalSince1970 < $1.date!.timeIntervalSince1970 })
            result = sortedActionsArray
        }
        return result
    }
    
    // Get Stake for Goal
    func getStake() -> Float {
        
        var result = Float()
        
        for action in getActions() {
            result += action.stake
        }
        
        return result
    }
    
    // Delete Action from Goal and Save Context
    func delete(_ action: Action) {
        
        // Deleted Action -10 points
        points.deduct(10)
        
        let managedObject = action as NSManagedObject
        SSCoreDataManager.instance.managedObjectContext.delete(managedObject)
        SSCoreDataManager.instance.saveContext()
    }
    
    // Delete Goal and Save Context
    func deleteGoal() {
        
        // Deleted Goal -50 points
        points.deduct(50)
        
        let managedObject = self as NSManagedObject
        SSCoreDataManager.instance.managedObjectContext.delete(managedObject)
        SSCoreDataManager.instance.saveContext()
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
        if status == .complete { points.add(50) }
        
        SSCoreDataManager.instance.saveContext()
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
}
