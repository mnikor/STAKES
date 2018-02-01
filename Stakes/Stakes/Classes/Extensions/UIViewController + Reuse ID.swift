//
//  UIViewController + HideKeyboard.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit


extension UIViewController {
    
    
    // MARK: Storyboards name
    enum SSStoryboardName: String {
        case main = "Main"
        case home = "Home"
        case menu = "Menu"
    }
    
    
    // MARK: Instantiate ViewController from Storyboards
    class func instantiate(_ name: SSStoryboardName) -> UIViewController {
        
        let path = Bundle.main.resourcePath!.appending("/Resources/Storyboards")
        let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle(path: path))
        // SSLocalizationManager.sharedManager.localizedStoryboard(name: type.rawValue)
        
        return storyboard.instantiateViewController(withIdentifier: self.reuseID)
    }
    
    
    // MARK: ID from Class Name
    public static var reuseID: String {
        return String(describing: self)
    }
}
