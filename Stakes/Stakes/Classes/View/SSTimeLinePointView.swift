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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settingsUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settingsUI()
    }
    
    
    // MARK: Public funcs
    func selectedView() {
        
        let newColor = UIColor.colorFrom(colorType: .red)
        backgroundColor = newColor
        layer.borderColor = newColor.cgColor
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
        backgroundColor = UIColor.colorFrom(colorType: .defaultBlack)
    }
}
