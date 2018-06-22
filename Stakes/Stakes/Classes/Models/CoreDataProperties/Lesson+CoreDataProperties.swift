//
//  Lesson+CoreDataProperties.swift
//  
//
//  Created by Anton Klysa on 5/25/18.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var color: String?
    @NSManaged public var content: String?
    @NSManaged public var goalDate: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var isLocked: Bool
    @NSManaged public var isTracking: Bool
    @NSManaged public var points: Float
    @NSManaged public var title: String?

}
