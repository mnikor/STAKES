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
    
    
    // MARK: Private properties
    private let points = SSPoint()
    
    
    // MARK: Initializers
    convenience init() {
        self.init(entity: SSCoreDataManager.instance.entityForName(entityName: .action), insertInto: SSCoreDataManager.instance.managedObjectContext)
    }
    
    
    // MARK: Public funcs
    
    // Edit Action Values
    func changeAction(name: String, date: Date, stake: Float) {
        
        let newDate = date as NSDate
        
        // Change Due Date -2 points
        if self.date != newDate {
            // TODO: Show alert "Change Action Date -2 points Yes/No?"
            points.deduct(2)
        }
        
        // Delete stake -10 points
        if stake == 0.0 {
            points.deduct(10)
        }
        
        self.name = name
        self.date = newDate
        self.stake = stake
        
        SSCoreDataManager.instance.saveContext()
    }
    
    // Change Action Status
    func changeStatus(_ status: GoalStatusType) {
        
        let pointsForCurrentStake = points.calculatePointsFor(stake: self.stake)
        
        self.status = status.rawValue
        switch status {
        case .complete:
            points.add(pointsForCurrentStake)
            if self.goal?.calculateСompletion() == 100 {
                
                goal?.changeStatus(.complete)
                SSMessageManager.showMainCustomAlertWith(title: .success, and: .goalAchieved, onViewController: nil)
            }
        case .missed:
            points.deduct(pointsForCurrentStake)
        case .wait: break
        }
        
        SSCoreDataManager.instance.saveContext()
    }
}
