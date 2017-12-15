//
//  SSPoint.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation

class SSPoint {
    
    
    // MARK: Private Properties
    private let userDefaults = UserDefaults.standard
    private let pointKey = "currentPoints"
    
    
    // MARK: Public Properties
    var currentPoints: Int {
        get {
            return userDefaults.integer(forKey: pointKey)
        }
        set {
            userDefaults.set(newValue, forKey: pointKey)
        }
    }
    
    
    // MARK: Public funcs
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
        currentPoints += points
    }
    
    func deduct(_ points: Int) {
        currentPoints -= points
    }
}
