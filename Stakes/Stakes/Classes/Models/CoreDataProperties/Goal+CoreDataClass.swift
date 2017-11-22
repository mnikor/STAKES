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
    case complete = "complete"
    case missed = "missed"
}


@objc(Goal)
public class Goal: NSManagedObject {
    
    
    // MARK: Initializers
    convenience init() {
        self.init(entity: SSCoreDataManager.instance.entityForName(entityName: .goal), insertInto: SSCoreDataManager.instance.managedObjectContext)
    }
    
    
    // MARK: Public funcs
    
    // Create new Action for current Goal and Save Context
    func createAction(name: String, date: Date) -> Action {
        let newAction = Action()
        
        newAction.goal = self
        newAction.name = name
        newAction.date = date as NSDate
        newAction.stake = self.stake / Float(self.getActions().count)
        
        SSCoreDataManager.instance.saveContext()
        return newAction
    }
    
    // Set properties for current Goal and Save Context
    func make(name: String, date: Date, stake: Float?) {
        
        self.name = name
        self.date = date as NSDate
        self.stake = stake ?? 0.0
        self.addToActions(createAction(name: name, date: date))
    }
    
    // Get Action array sorted by Date for current Goal
    func getActions() -> [Action] {
        var result = [Action]()
        
        if let array = self.actions?.array as? [Action] {
            
            let sortedActionsArray = array.sorted(by: { $0.date!.timeIntervalSince1970 > $1.date!.timeIntervalSince1970 })
            result = sortedActionsArray
        }
        return result
    }
    
    // Delete Action from Goal and Save Context
    func delete(_ action: Action) {
        
        let managedObject = action as NSManagedObject
        SSCoreDataManager.instance.managedObjectContext.delete(managedObject)
        SSCoreDataManager.instance.saveContext()
    }
    
    // Delete Goal and Save Context
    func deleteGoal() {
        
        let managedObject = self as NSManagedObject
        SSCoreDataManager.instance.managedObjectContext.delete(managedObject)
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
