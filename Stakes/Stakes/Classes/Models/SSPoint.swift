//
//  SSPoint.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation


@objc protocol SSPointChangeValueDelegate {
    
    func pointChanged(withAnimation: Bool)
}


class SSPoint {
    
    
    // MARK: Delegate
    weak var delegate: SSPointChangeValueDelegate?
    
    
    // MARK: Private Properties
    private let userDefaults = UserDefaults.standard
    private let pointKey = SSConstants.keys.kPointKey.rawValue
    private let tempPointKey = SSConstants.keys.kTempPointKey.rawValue
    
    
    // MARK: Public Properties
    var currentPoints: Int {
        get {
            return userDefaults.integer(forKey: pointKey)
        }
        set {
            tempPoints = currentPoints
            userDefaults.set(newValue, forKey: pointKey)
        }
    }
    var tempPoints: Int {
        get {
            return userDefaults.integer(forKey: tempPointKey)
        }
        set {
            userDefaults.set(newValue, forKey: tempPointKey)
        }
    }
    
    
    // MARK: Public funcs
    
    func updatePointsLabel(withAnimation: Bool) {
        delegate?.pointChanged(withAnimation: withAnimation)
    }
    
    func getCurrentPoints() -> String {
        return currentPoints < 0 ? currentPoints.description : "+" + currentPoints.description
    }
    
    func getPointsFor(stake: Float) -> String {
        return "+" + calculatePointsFor(stake: stake).description
    }
    
    func calculatePointsFor(stake: Float) -> Int {
        return stake == 0.0 ? 5 : Int(stake + 6.0)
    }
    
    func add(_ points: Int) {
        
        // Add points
        currentPoints += points
        delegate?.pointChanged(withAnimation: true)
        
        // Lesson tracking
        if let trackingLesson = SSLessonsManager.instance.trackingLesson {
            trackingLesson.setPoints(trackingLesson.points + Float(points))
        }
        
        // Show alert when first points earned
        let userDefaults = UserDefaults.standard
        let key = SSConstants.keys.kFirstEarnPoint.rawValue
        
        if !userDefaults.bool(forKey: key) {
            
            SSMessageManager.showCustomAlertWith(message: .firstPointsEarned, onViewController: nil)
            userDefaults.set(true, forKey: key)
        }
    }
    
    func deduct(_ points: Int) {
        
        currentPoints -= points
        delegate?.pointChanged(withAnimation: true)
    }
}
