//
//  SSTimeLinePointView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/14/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSTimeLinePointView: UIView {
    
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingsUI()
    }
    
    
    // MARK: Public funcs
    func makeBorder(width: CircleBorderSize, color: UIColor) {
        
        layer.borderColor = color.cgColor
        layer.borderWidth = width.rawValue
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
        backgroundColor = UIColor.colorFrom(colorType: .defaultBlack)
    }
}
