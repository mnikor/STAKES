//
//  SSSettingsViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSSettingsViewController: SSBaseViewController {
    
    
    // MARK: Outlets
    
    // Labels
    @IBOutlet weak var titleLabel: SSBaseLabel!
    @IBOutlet weak var remindMeLabel: SSBaseLabel!
    @IBOutlet weak var daysBeforeLabel: SSBaseLabel!
    @IBOutlet weak var syncLabel: SSBaseLabel!
    @IBOutlet var daysLabels: [SSBaseLabel]!
    
    // Switches
    @IBOutlet weak var oneDaySwitch: UISwitch!
    @IBOutlet weak var threeDaysSwitch: UISwitch!
    @IBOutlet weak var sevenDaysSwitch: UISwitch!
    @IBOutlet weak var fifteenDaysSwitch: UISwitch!
    @IBOutlet weak var syncCalendarSwitch: UISwitch!
    
    
    // MARK: Private Properties
    private let userDefaults = UserDefaults.standard
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createCirclesBackground()
        settingsUI()
    }
    
    override func createCirclesBackground() {
        
        let circleView = UIImageView(image: UIImage(named: "background_settings"))
        circleView.frame = self.view.frame
        view.insertSubview(circleView, at: 0)
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedOneDaySwitch(_ sender: UISwitch) {
        switchStateFor(.oneDay)
    }
    
    @IBAction func tappedThreeDaysSwitch(_ sender: UISwitch) {
        switchStateFor(.threeDays)
    }
    
    @IBAction func tappedSevenDaysSwitch(_ sender: UISwitch) {
        switchStateFor(.week)
    }
    
    
    @IBAction func tappedFifteenDaysSwitch(_ sender: UISwitch) {
        switchStateFor(.twoWeeks)
    }
    
    @IBAction func tappedSyncSwitch(_ sender: UISwitch) {
        switchStateFor(SSConstants.keys.kSyncWithCalendar.rawValue)
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        // Set colors
        let lightColor = UIColor.colorFrom(colorType: .light)
        let blackColor = UIColor.colorFrom(colorType: .createActionBlack)
        let redColor = UIColor.colorFrom(colorType: .settingsRed)
        
        titleLabel.textColor = lightColor
        daysBeforeLabel.textColor = blackColor
        remindMeLabel.textColor = redColor
        syncLabel.textColor = redColor
        for labels in daysLabels {
            labels.textColor = blackColor
        }
        
        // Set values
        oneDaySwitch.setOn(userDefaults.bool(forKey: convertToKey(.oneDay)), animated: false)
        threeDaysSwitch.setOn(userDefaults.bool(forKey: convertToKey(.threeDays)), animated: false)
        sevenDaysSwitch.setOn(userDefaults.bool(forKey: convertToKey(.week)), animated: false)
        fifteenDaysSwitch.setOn(userDefaults.bool(forKey: convertToKey(.twoWeeks)), animated: false)
        syncCalendarSwitch.setOn(userDefaults.bool(forKey: SSConstants.keys.kSyncWithCalendar.rawValue), animated: false)
        
        titleLabel.sizeByTextFor(lines: 1)
    }
    
    private func switchStateFor(_ type: SSReminderType) {
        
        let key = convertToKey(type)
        switchStateFor(key)
    }
    
    private func switchStateFor(_ key: String) {
        
        let currentState = userDefaults.bool(forKey: key)
        userDefaults.set(!currentState, forKey: key)
    }
    
    private func convertToKey(_ type: SSReminderType) -> String {
        
        return type.rawValue.description
    }
}
