//
//  SSAnalyticsManager.swift
//  Stakes
//
//  Created by Anton Klysa on 9/14/17.
//  Edited by Dmitry Nezhidenko on 1/18/18.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import Flurry_iOS_SDK

class SSAnalyticsManager {
    
    
    // MARK: Private Properties
    private let kFlurryID: String = "QD88JB5TW3GV8WGC6PNY"
    
    
    // MARK: Singleton
    static let instance = SSAnalyticsManager()
    private init() {}
    
    
    //MARK: Activation
    class func startAnalytics() {
        
        // Adding Flurry Analitics
        Flurry.startSession(SSAnalyticsManager.instance.kFlurryID, with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
    }
    
    
    //MARK: Add Event
    class func logEvent(_ event: SSConstants.analytics) {
        
        Flurry.logEvent(event.rawValue)
    }
    
    
    //MARK: Add Event with parameters
    class func logEvent(_ event: SSConstants.analytics, with parameters: [String : Any]) {
//        ["User": SSConstants.userID!]
        Flurry.logEvent(event.rawValue, withParameters: parameters)
    }
    
    
    //MARK: Users screen path
    class func addScreen(screen: UIViewController) {
        
        Flurry.logPageView()
    }
    
    
    //MARK: Errors
    class func logError(error: Error) {
        Flurry.logError("Error", message: error.localizedDescription, error: error)
    }
}
