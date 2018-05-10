//
//  AppDelegate.swift
//  Stakes
//
//  Created by Anton Klysa on 11/8/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import UserNotifications
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    let notificationDelegate = SSNotificationDelegate()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // MARK: Fabric
        Fabric.with([Crashlytics.self])
        
        // MARK: Flurry Analytics
        SSAnalyticsManager.startAnalytics()
        
        // MARK: IQKeyboardManagerSwift
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarTintColor = UIColor.colorFrom(colorType: .red)
        
        // MARK: Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // MARK: Lessons Initializers
        SSLessonsManager.initLessons()
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        // MARK: Check what a run of app, for display Onboarding screen
        
        let launchKey = SSConstants.keys.kLaunch.rawValue
        var rootVC = UIViewController()
        if UserDefaults.standard.bool(forKey: launchKey) {
            rootVC = UIStoryboard.getSlideMenuController()
        } else {
            rootVC = SSIntroductionPageViewController.instantiate(.main)
            UserDefaults.standard.set(true, forKey: launchKey)
        }
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        
        // MARK: Register Local Notifications
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.delegate = notificationDelegate
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                /* -- Push
            let application = UIApplication.shared
            if granted { application.registerForRemoteNotifications() }
                */
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        SSCoreDataManager.instance.saveContext()
    }
}

