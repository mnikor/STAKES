//
//  SSLevel.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/14/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

// MARK: Levels Type
enum LevelsType: String {
    case beginner, advanced, serialAchiever, pro, grandmaster
    
    static let types: [LevelsType] = [beginner, advanced, serialAchiever, pro, grandmaster]
}

// MARK: Status Levels Type
enum StatusLevelsType: String {
    case active, disable, progress
}

// MARK: Level limits
struct Limits {
    let points: Int
    let goalMid: Int // 3-6 month
    let goalLong: Int // <10 month
    
    func compare(limit: Limits) -> Bool {
        
        // Compare Points
        guard self.points >= limit.points else { return false }
        
        // Compare mid term Goals achieved or long use as mid term
        if self.goalMid >= limit.goalMid || self.goalLong >= limit.goalMid {
            
            // Compare long term Goals achieved
            if self.goalLong >= limit.goalLong {
                
                // Compare mid term Goals achieved
                return limit.goalLong == 0 || self.goalMid >= limit.goalMid
            }
        }
        return false
    }
}

class Level {
    
    
    // MARK: - Public Properties
    let type: LevelsType
    let title: String
    let description: String
    let limits: [Limits]
    
    var isCurrentLevel: Bool = false
    var image: String = ""
    private var percent: Int?
    var completionPercentage: Int {
        //for completionPercentage
        get {
            let currentLimit = SSLevelsManager.instance.currentLimit!
            let limit = limits.first!
            
            let limitItems: [Int] = [limit.points, limit.goalMid, limit.goalLong]
            let currentItems: [Int] = [currentLimit.points, currentLimit.goalMid, currentLimit.goalLong]
            
            var count: Int = 0
            var sum: Int = 0
            
            for item in limitItems {
                if item != 0 {
                    
                    // Compute percent for each limits and add to sum
                    sum += computePercent(currentItems[count], item)
                    count += 1
                }
            }
            
            // Average percent all limits or 0
            return count == 0 ? 0 : sum / count
        }
        set(value) {
            percent = value
        }
    }
    
    var status: StatusLevelsType {
        didSet {
            if status == .progress {
                image = type.rawValue + "_disable"
            } else {
                image = type.rawValue + "_" + status.rawValue
            }
        }
    }
    
    
    // MARK: - Initializers
    init(type: LevelsType) {
        self.type = type
        
        var tTitle = type.rawValue.uppercased()
        var tStatus: StatusLevelsType = .disable
        
        // Define Title and Description
        switch type {
        case .beginner:
            description = ""
            limits = [Limits(points: 0, goalMid: 0, goalLong: 0)]
            tStatus = .active
        case .advanced:
            description = "Minimum 300 points and \n1 mid term (3-6 month) goal achieved"
            limits = [Limits(points: 300, goalMid: 1, goalLong: 0)]
        case .serialAchiever:
            tTitle = "SERIAL ACHIEVER"
            description = "Minimum 600 points and \n3 mid term goals achieved"
            limits = [Limits(points: 600, goalMid: 3, goalLong: 0)]
        case .pro:
            description = "Minimum 1000 points, \n1 long term (>10 month) goal and \n5 mid-term \nOr 2 long term goals achieved."
            limits = [Limits(points: 1000, goalMid: 5, goalLong: 1),
                      Limits(points: 1000, goalMid: 0, goalLong: 2)]
        case .grandmaster:
            description = "Minimum 2000 points, \n3 long term goals and \n7 mid term achieved."
            limits = [Limits(points: 2000, goalMid: 7, goalLong: 3)]
        }
        
        self.title = tTitle
        self.status = tStatus
    }
    
    
    // MARK: - Private funcs
    private func computePercent(_ this: Int, _ need: Int) -> Int {
        
        guard need != 0 else { return 100 }
        if self.percent != nil {
            return self.percent!
        }
        var percent: Int = (100 * this) / need
        percent = percent > 100 ? 100 : percent
        
        return percent
    }
}
