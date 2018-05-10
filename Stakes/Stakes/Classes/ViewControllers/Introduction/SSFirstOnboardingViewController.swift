//
//  SSFirstOnboardingViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSFirstOnboardingViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet var labelsArray: [SSBaseLabel]!
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for label in labelsArray {
            
            label.font = UIFont(name: SSConstants.fontType.bigCaslon.rawValue, size: label.font.pointSize)
        }
        setDefaultReminderSettings()
    }
    
    
    // MARK: Private funcs
    
    // Set Default values for Reminder Settings and Synchronise with Calendar
    private func setDefaultReminderSettings() {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: SSReminderType.toDay.rawValue.description)
        userDefaults.set(true, forKey: SSReminderType.oneNight.rawValue.description)
        userDefaults.set(true, forKey: SSReminderType.oneDay.rawValue.description)
        userDefaults.set(false, forKey: SSReminderType.threeDays.rawValue.description)
        userDefaults.set(true, forKey: SSReminderType.week.rawValue.description)
        userDefaults.set(true, forKey: SSReminderType.twoWeeks.rawValue.description)
        
        // Sync with Calendar
        userDefaults.set(true, forKey: SSConstants.keys.kSyncWithCalendar.rawValue)
    }
}
