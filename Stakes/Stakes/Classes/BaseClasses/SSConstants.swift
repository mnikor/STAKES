//
//  SSConstants.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/16/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

struct SSConstants {
    
    
    // MARK: Constant properties
    static let appStoreLink = "https://itunes.apple.com/us/app/the-bold/id1335550087?ls=1&mt=8"
    static let instagramURL = URL(string: "instagram://app")!
    static let stakes: [Float : purchase] = [0.0    : .zeroStake,
                                             1.99   : .twoStake,
                                             2.99   : .threeStake,
                                             3.99   : .fourStake,
                                             4.99   : .fiveStake,
                                             5.99   : .sixStake,
                                             7.99   : .eightStake,
                                             9.99   : .tenStake,
                                             11.99  : .twelveStake,
                                             13.99  : .fourteenStake,
                                             15.99  : .sixteenStake,
                                             19.99  : .twentyStake,
                                             24.99  : .twentyFiveStake,
                                             30.99  : .thirtyOneStake,
                                             40.99  : .fortyOneStake,
                                             59.99  : .sixtyStake,
                                             99.99  : .hundredStake]
    
    
    // MARK: Fonts Constants
    enum fontType: String {
        case helvetica = "Helvetica"
        case helveticaBold = "Helvetica-Bold"
        case bigCaslon = "BigCaslon-Medium"
    }
    
    
    // MARK: Color Constants
    enum colorType: Int {
        case defaultBlack = 0x646464
        case red = 0xFF8080
        case light = 0x9B9B9B
        case dueDate = 0x9C9C9C
        case underlineView = 0x979797
        case createActionBlack = 0x5F5F5F
        case redTitleAlert = 0xFF7979
        case blackTitleAlert = 0x4A4A4A
        case blue = 0x5D9BE5
        case nextAction = 0x4A90E2
        case settingsRed = 0xFF6D6D
        case green = 0x64C3FF
    }
    
    
    // MARK: Keys
    enum keys: String {
        case kLocaleIdentifier = "en"
        case kNotificationActionID = "Complete"
        case kNotificationCategoryID = "ReminderCategory"
        case kLaunch = "isLaunched"
        case kPointKey = "currentPoints"
        case kTempPointKey = "temporaryPoints"
        case kFirstEarnPoint = "FirstEarnPoint"
        case kActionWithoutStake = "ActionWithoutStake"
        
        case kCurrentLevelType
        case kShowNewFeaturesAlert
        case kShowWarningInAppPurchases
        
        case kCompletedActions
        case kSyncWithCalendar
        case kFeedbackText
        case kCreatedLessons
    }
    
    
    // MARK: Analytics
    enum analytics: String {
        
        /*
         Average number of actions per user
         Number of stakes set
         Overall stake amount
         */
        case allActions = "Action Created"//"User all actions"
        
        /*
         Number of Goals set overall
         Average number of goals per user
         */
        case allGoals = "Goals set overall"
        
        case unlockPressed = "The unlock lesson button is pressed"
        
        // Number of times stake is changed
        case amountStakeChanges = "Stake is changed"
        
        // Number of missed actions
        case missedActions = "Missed Actions"
        
        // Number of completed actions
        case completedActions = "Completed Actions"
        
        // Number of actions deleted. (Number of times Actions are deleted)
        case deletedActions = "Deleted Actions"
        
        // Number of achieved goals
        case achievedGoals = "Achieved Goals"
        
        // Number of goals deleted
        case deletedGoals = "Deleted Goals"
        
        // Number of due date changed
        case dueDateChanged = "Due Date Changed "
        
        // Number of times goal is shared
        case shareGoal = "Goal is shared"
        
        // Number of goals locked
        case lockedGoal = "Goal is locked"
    }
    
    
    // MARK: Purchase
    
    // Purchase products end ID
    enum purchase: String {
        case zeroStake
        case twoStake
        case threeStake
        case fourStake
        case fiveStake
        case sixStake
        case eightStake
        case tenStake
        case twelveStake
        case fourteenStake
        case sixteenStake
        case twentyStake
        case twentyFiveStake
        case thirtyOneStake
        case fortyOneStake
        case sixtyStake
        case hundredStake
    }
    
    // MARK: Get Product ID's for Purchase
    static func getPurchaseID(_ stake: Float) -> String? {
        
        for key in stakes.keys {
            if key == stake, let id = stakes[key] {
                
                let bundleID = Bundle.main.bundleIdentifier!
                return bundleID + "." + id.rawValue
            }
        }
        return nil
    }
}
