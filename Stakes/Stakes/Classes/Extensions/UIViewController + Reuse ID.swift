//
//  UIViewController + HideKeyboard.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    // MARK: ID from Class Name
    public static var reuseID: String {
        return String(describing: self)
    }
}
