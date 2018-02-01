//
//  UIStoryboard+Stakes.swift
//  Stakes
//
//  Created by Anton Klysa on 11/8/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift


extension UIStoryboard {
    
    
    // Instantiate Slide Menu Controller
    class func getSlideMenuController() -> UIViewController {
        
        let mainViewController = SSMainNavigationController.instantiate(.home)
        let leftViewController = SSMenuViewController.instantiate(.menu)
        return SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
    }
}
