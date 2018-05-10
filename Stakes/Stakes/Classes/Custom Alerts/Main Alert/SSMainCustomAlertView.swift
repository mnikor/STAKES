//
//  SSMainCustomAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSMainCustomAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var contentView: UIView!
    
    
    // MARK: Public properties
    var messageType: SSMessageManager.MessageTypeDescription!
    
    
    // MARK: Initializers
    init(type: SSMessageManager.MessageTypeDescription) {
        super.init(frame: .zero)
        
        self.messageType = type
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
    }
    
    
    // MARK: Actions funcs
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.closeCustomAlert()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {

        let messageBlackColor = UIColor.colorFrom(colorType: .blackTitleAlert)

        // Set Labels Text Color
        descriptionLabel.textColor = messageBlackColor
        
        // Set Values
        descriptionLabel.text = messageType.rawValue
        if messageType == .newFeatures {
            descriptionLabel.textAlignment = .left
        }
        
        var image: UIImage? = UIImage()
        switch messageType! {
        case .knowledge:
            image = UIImage(named: "knowledge_alert")
        case .masteryLevel:
            image = UIImage(named: "next_level_of_mastery")
            descriptionLabel.text?.append("\(SSLevelsManager.instance.getCurrentLevel().title) Keep mastering your life skills.")
        case .purchaseDone, .unlockedLesson:
            image = UIImage(named: "gift_alert")
        case .levelsInfo:
            image = UIImage(named: "sports_icon")
            alertImageView.contentMode = .scaleAspectFit
        default:
            alertImageView.removeFromSuperview()
            return
        }
        alertImageView.image = image
    }
}
