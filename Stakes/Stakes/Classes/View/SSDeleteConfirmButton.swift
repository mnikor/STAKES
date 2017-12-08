//
//  SSSelectCircleGoalButton.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/22/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSSelectCircleGoalButton: SSBaseButton {
    
    
    // MARK: Public Properties
    var selectedGoal: Goal?
    
    
    // MARK: Overriden funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
    }
}
