//
//  Action+CoreDataProperties.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/17/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//
//

import Foundation
import CoreData


extension Action {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var stake: Float
    @NSManaged public var status: String?
    @NSManaged public var goal: Goal?

}
