//
//  UIColor+FromRGB.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/20/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func fromRGB(rgbValue: Int) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func colorFrom(colorType: SSConstants.colorType) -> UIColor {
        return fromRGB(rgbValue: colorType.rawValue)
    }
}
