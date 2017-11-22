//
//  SSTimeLinePointView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/14/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSTimeLinePointView: UIView {

    
    // MARK: Overriden funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
    }
}
