//
//  SSLevelsManager.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/14/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSLevelsManager {
    
    // MARK:  - Singleton
    static let instance: SSLevelsManager = SSLevelsManager()
    private init() {
        var levels = [Level]()
        for type in LevelsType.types {
            let level = Level(type: type)
            levels.append(level)
        }
        self.levelsArray = levels
    }
    
    
    // MARK: - Public Properties
    var currentLimit: Limits!
    var levels: [Level] {
        
        let currentLevel = getCurrentLevel()
        var updatedLevels = [Level]()
        var isNextProgress = false
        var isOtherLevelsDisable = false
        for level in levelsArray {
            level.status = .active
            
            // Set Disable Levels
            if isOtherLevelsDisable {
                level.status = .disable
            }
            
            // Set Level in progress
            if isNextProgress {
                level.status = .progress
                isNextProgress = false
                isOtherLevelsDisable = true
            }
            
            // Set Active Levels
            if level.type == currentLevel.type {
                level.isCurrentLevel = true
                isNextProgress = true
            }
            
            updatedLevels.append(level)
        }
        return updatedLevels
    }
    
    
    // MARK: - Private Properties
    private let levelsArray: [Level]
    
    
    // MARK: - Public funcs
    func getCurrentLevel() -> Level {
        
        let points: Int = SSPoint().currentPoints
        let achievedGoals: [Goal] = getAchievedGoals()
        
        let goalMidArray: [Goal] = achievedGoals.filter({ $0.timeSpentType == .mid })
        let goalLongArray: [Goal] = achievedGoals.filter({ $0.timeSpentType == .long })
        
        currentLimit = Limits(points: points, goalMid: goalMidArray.count, goalLong: goalLongArray.count)
        var currentLevel = levelsArray.first!
        
        for level in levelsArray {
            for limit in level.limits {

                if currentLimit.compare(limit: limit) {
                    currentLevel = level
                }
            }
        }
        
        currentLevel.status = .active
        return currentLevel
    }
    
    
    // MARK: - Private funcs
    func getAchievedGoals() -> [Goal] {
        let goals: [Goal] = SSCoreDataManager.instance.loadObjectsFromCoredata(type: .goal) as! [Goal]
        let achievedGoals = goals.filter({ $0.status! == GoalStatusType.complete.rawValue })
        
        return achievedGoals
    }
}
