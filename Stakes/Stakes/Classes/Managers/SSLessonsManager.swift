//
//  SSLessonsManager.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/12/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

// MARK: Image color type
enum LessonColorType: String {
    case red, blue
}


class SSLessonsManager {
    
    // MARK: Text Size type enum
    enum TextSize: CGFloat {
        case big = 16.0
        case main = 10.0
    }
    
    
    // MARK:  - Singleton
    static let instance = SSLessonsManager()
    private init() {
        
        // Get all Lessons
        self.lessonsArray = SSCoreDataManager.instance.loadObjectsFromCoredata(type: .lesson) as! [Lesson]
    }
    
    
    // MARK: - Public Properties
    
    // All Lessons
    var lessonsArray: [Lesson]
    
    // Get current tracking Lesson
    var trackingLesson: Lesson? {
        let lesson = lessonsArray.filter({ $0.isTracking == true })
        return lesson.first
    }
    
    
    // MARK: - Inititializers Lessons (Only first run)
    static func initLessons() {
        
        let userDefaults = UserDefaults.standard
        let key = SSConstants.keys.kCreatedLessons.rawValue

        guard !userDefaults.bool(forKey: key) else { return }
        
        let titles: [String] = ["Start from the end result in Mind",
                                "The Power of an Action plan",
                                "Moving from point A to point B",
                                "Finding your Flow",
                                "Is your goal Realistic?",
                                "Pareto Principle",
                                "Overcoming Resistance",
                                "Unlimiting Beliefs",
                                "Pivoting",
                                "The Compound Effect",
                                "The Growth Environment",
                                "Knowledge is not Power until it’s applied"]
        
        var id = 1
        for i in 0..<titles.count {
            
            let lesson = Lesson()
            var color: LessonColorType = .red
            
            switch id {
            case 1, 4, 6, 8, 9, 11, 12: color = .blue
            default: color = .red
            }
            lesson.make(id: String(id), title: titles[i], color: color)
            
            id += 1
        }
        userDefaults.set(true, forKey: key)
    }
    
    
    // MARK: - Public funcs
    
    // Track Goal
    func track(_ goalDate: NSDate) {
        
        if trackingLesson?.goalDate == nil {
            trackingLesson?.setGoalDate(goalDate)
        }
    }
    
    // Check current trackingLesson
    func updateTrackingLesson() {
        
        guard let trackingLesson = self.trackingLesson else { return }
        
        // Check conditions of executing
        if trackingLesson.progressGoalDate && trackingLesson.progressPoints >= 100 {
            
            // Remove tracking status and unlock lesson
            let previousLessonID = trackingLesson.idWrapper
            let oldLesson = Lesson.getLessonBy(id: previousLessonID)!
            oldLesson.setIsLocked(false)
            oldLesson.setIsTracking(false)
            
            // Set new tracking lesson
            for index in previousLessonID..<self.lessonsArray.count {
                let newTrackingLesson = self.lessonsArray[index]
                if newTrackingLesson.isLocked {
                    newTrackingLesson.setIsTracking(true)
                    return
                }
            }
        }
    }
    
}
