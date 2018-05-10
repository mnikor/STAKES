//
//  Lesson+CoreDataClass.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/13/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Lesson)
public class Lesson: NSManagedObject {
    
    
    // MARK: - Initializers
    convenience init() {
        self.init(entity: SSCoreDataManager.instance.entityForName(entityName: .lesson), insertInto: SSCoreDataManager.instance.managedObjectContext)
    }
    
    
    // MARK: - Public properties
    var idWrapper: Int {
        return Int(self.id!)!
    }
    var partialTitle: String {
        
        let index: Float = Float((title!.count * progressPoints) / 100)
        let partString = title!.prefix(lroundf(index))
        var newTitle = String(partString)
        
        if progressPoints != 100 {
            newTitle += "..."
        }
        
        return newTitle
    }
    var mainImage: UIImage? {
        let imageNamedMain = self.colorWrapper == .red ? "book_red" : "book_blue"
        return UIImage(named: imageNamedMain)
    }
    var lockImage: UIImage? {
        let imageNamedLock = self.colorWrapper == .red ? "lock_red" : "lock_blue"
        return UIImage(named: imageNamedLock)
    }
    
    var progressPoints: Int {
        // Percent of point
        let percent = (100 * self.points) / 30
        
        return percent > 100 ? 100 : lroundf(percent)
    }
    
    var progressGoalDate: Bool {
        
        if let goalDate = self.goalDate as Date? {
            // 30 days
            let timeInterval: TimeInterval = 30 * 24 * 3600
            let needDate = goalDate.addingTimeInterval(timeInterval)
            let result = Date.daysBetween(firstDate: needDate, and: Date())
            
            return result >= 0
        }
        return false
    }
    
    
    // MARK: - Private properties
    private var colorWrapper: LessonColorType {
        return self.color! == "red" ? .red : .blue
    }
    
    
    // MARK: - Public funcs
    
    // Set properties for current Lesson and Save Context
    func make(id: String, title: String, color: LessonColorType) {
        
        self.id = id
        self.title = title
        self.content = id
        self.color = color.rawValue
        
        switch id {
        case "1", "2":
            self.isLocked = false
        case "3":
            self.points = 0.0
            self.isLocked = true
            self.isTracking = true
        default:
            self.isLocked = true
        }
        
        SSCoreDataManager.instance.saveContext()
    }
    
    // --- Change properties and Save Context
    
    func setIsTracking(_ bool: Bool) {
        self.isTracking = bool
        SSCoreDataManager.instance.saveContext()
    }
    
    func setIsLocked(_ bool: Bool) {
        self.isLocked = bool
        SSCoreDataManager.instance.saveContext()
    }
    
    func setPoints(_ points: Float) {
        self.points = points
        SSCoreDataManager.instance.saveContext()
    }
    
    func setGoalDate(_ date: NSDate?) {
        self.goalDate = date
        SSCoreDataManager.instance.saveContext()
    }
    
    
    // MARK: Class funcs
    
    // Fetch Lesson from Core Data
    class func getLessonBy(id: Int) -> Lesson? {
        
        let fetchedResultsController = SSCoreDataManager.instance.fetchedResultsController(entityName: .lesson, keyForSort: "id", predicate: ["id": String(id)])
        do {
            try fetchedResultsController.performFetch()
            let fetchedResults = fetchedResultsController.fetchedObjects
            let fetchedAction = fetchedResults?.first as! Lesson
            return fetchedAction
        } catch {
            print(error)
        }
        return nil
    }
}
