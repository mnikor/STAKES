//
//  SSShareGoalAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSShareGoalAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var contentView: UIView!
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadFromNib()
        settingsUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.loadFromNib()
        settingsUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bounds = contentView.bounds
        self.frame.origin = CGPoint(x: (UIWindow().frame.width / 2.0) - (self.frame.width / 2.0), y: 20.0)
    }
    
    
    // MARK: Actions funcs
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.closeCustomAlert()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        let messageBlackColor = UIColor.colorFrom(colorType: .blackTitleAlert)
        
        // UI of View
        self.makeBorder(width: .small, color: .lightGray)
        self.layer.cornerRadius = 8.0
        self.backgroundColor = .white
        
        // Set Labels Text Color
        titleLabel.textColor = messageBlackColor
        pointsLabel.textColor = UIColor.fromRGB(rgbValue: 0xA5B0FF)
        
        // Set values
        titleLabel.text = SSMessageManager.MessageTypeDescription.share.rawValue
        pointsLabel.text = "+10"
    }
}
