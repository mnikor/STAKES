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
    
    convenience init() {
        self.init(entity: SSCoreDataManager.instance.entityForName(entityName: .action), insertInto: SSCoreDataManager.instance.managedObjectContext)
    }
}
