//
//  SSRightActionButton.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/15/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSRightActionButton: UIButton {
    
    
    // MARK: Private Properties
    private var buttonColor: UIColor = .white
    private var buttonImage: UIImage = UIImage()
    private let sizeButton: CGFloat = 60.0//69.0
    private let rightIndent: CGFloat = 7.0
    private let bottomIndent: CGFloat = 7.0//18.0
    
    
    // MARK: Initializers
    init(viewFrame: CGRect) {
        
        let buttonFrame = CGRect(x: viewFrame.width - sizeButton - rightIndent,
                                 y: viewFrame.height - sizeButton - bottomIndent,
                                 width: sizeButton, height: sizeButton)
        super.init(frame: buttonFrame)
        
        backgroundColor = buttonColor
        setImage(buttonImage, for: .normal)
        makeCircleWithShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Private funcs
    private func makeCircleWithShadow() {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = false
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = frame.width / 2
    }
}
