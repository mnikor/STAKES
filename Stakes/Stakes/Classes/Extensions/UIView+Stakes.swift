//
//  UIView+Stakes.swift
//  Stakes
//
//  Created by Anton Klysa on 11/8/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import Foundation
import UIKit

enum SSAnimationDuration: TimeInterval {
    case normal = 0.3
    case fast = 0.1
    case slow = 0.5
}

extension UIView {
    
    class func isRTL() -> Bool{
        return UIView.appearance().semanticContentAttribute == .forceLeftToRight
    }
    
    //prefered way to animate -> used default normal duration
    class func ssAnimate(withAnimations animations: @escaping ()->(), completion: ((Bool)->())? = nil) {
        animate(withDuration: SSAnimationDuration.normal.rawValue, animations: animations, completion: completion)
    }
    
    //prefered way to animate with custom duration
    class func ssAnimate(withDuration duration: SSAnimationDuration, animations: @escaping ()->(), completion: ((Bool)->())? = nil) {
        self.animate(withDuration: duration.rawValue, animations: animations, completion: completion)
    }
}
