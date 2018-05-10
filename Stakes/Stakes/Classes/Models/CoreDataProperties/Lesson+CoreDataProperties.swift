//
//  Lesson+CoreDataProperties.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/13/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var isLocked: Bool
    @NSManaged public var isTracking: Bool
    @NSManaged public var color: String?
    @NSManaged public var content: String?
    @NSManaged public var goalDate: NSDate?
    @NSManaged public var points: Float

}
