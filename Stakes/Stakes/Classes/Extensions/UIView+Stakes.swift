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

enum SSBorderSize: CGFloat {
    case small = 1.0
    case medium = 3.0
    case large = 5.0
}

extension UIView {
    
    // Border
    func makeBorder(width: SSBorderSize, color: UIColor) {
        
        layer.borderColor = color.cgColor
        layer.borderWidth = width.rawValue
    }
    
    // Shadow
    func dropShadow(_ color: UIColor) {
        let opacity: Float = 1.0
        let offSet: CGSize = CGSize(width: -1, height: 1)
        let radius: CGFloat = 3.0
        let scale = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // Screenshot current view
    func makeScreenshot() -> UIImage? {
        
        let color = self.backgroundColor
        self.backgroundColor = .white
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.backgroundColor = color
        return image
    }
    
    
    // MARK: --- Constraints
    
    // Embed new view to current view by all bounds
    func embedWithConstraint(_ view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
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
