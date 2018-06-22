//
//  Action+CoreDataProperties.swift
//  
//
//  Created by Anton Klysa on 5/25/18.
//
//

import Foundation
import CoreData


extension Action {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var event_id: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var purchased: Bool
    @NSManaged public var stake: Float
    @NSManaged public var status: String?
    @NSManaged public var is_preliminarily_completed: Bool
    @NSManaged public var goal: Goal?

}
