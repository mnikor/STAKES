//
//  TableViewCell+ReuseID.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/21/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public static var reuseID: String {
        return String(describing: self)
    }
    
}
