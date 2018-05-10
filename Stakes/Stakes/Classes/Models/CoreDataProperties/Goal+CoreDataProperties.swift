//
//  Goal+CoreDataProperties.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 2/26/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var date: NSDate?
    @NSManaged public var event_id: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var stake: Float
    @NSManaged public var status: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var actions: NSOrderedSet?

}

// MARK: Generated accessors for actions
extension Goal {

    @objc(insertObject:inActionsAtIndex:)
    @NSManaged public func insertIntoActions(_ value: Action, at idx: Int)

    @objc(removeObjectFromActionsAtIndex:)
    @NSManaged public func removeFromActions(at idx: Int)

    @objc(insertActions:atIndexes:)
    @NSManaged public func insertIntoActions(_ values: [Action], at indexes: NSIndexSet)

    @objc(removeActionsAtIndexes:)
    @NSManaged public func removeFromActions(at indexes: NSIndexSet)

    @objc(replaceObjectInActionsAtIndex:withObject:)
    @NSManaged public func replaceActions(at idx: Int, with value: Action)

    @objc(replaceActionsAtIndexes:withActions:)
    @NSManaged public func replaceActions(at indexes: NSIndexSet, with values: [Action])

    @objc(addActionsObject:)
    @NSManaged public func addToActions(_ value: Action)

    @objc(removeActionsObject:)
    @NSManaged public func removeFromActions(_ value: Action)

    @objc(addActions:)
    @NSManaged public func addToActions(_ values: NSOrderedSet)

    @objc(removeActions:)
    @NSManaged public func removeFromActions(_ values: NSOrderedSet)

}
