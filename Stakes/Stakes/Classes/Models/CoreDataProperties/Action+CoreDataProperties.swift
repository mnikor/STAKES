//
//  Action+CoreDataProperties.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 1/10/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
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
    @NSManaged public var stake: Float
    @NSManaged public var status: String?
    @NSManaged public var purchased: Bool
    @NSManaged public var goal: Goal?

}
