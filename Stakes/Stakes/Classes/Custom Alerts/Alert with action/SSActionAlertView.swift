//
//  SSDeleteActionAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/13/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit


class SSActionAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var yesButtonLabel: SSBaseLabel!
    @IBOutlet weak var noButtonLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var starImageView: UIImageView!
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
    
    @IBAction func tappedYesButton(_ sender: SSBaseButton) {
        delegate?.actionCustomAlert!()
    }
    
    @IBAction func tappedNoButton(_ sender: SSBaseButton) {
        self.delegate?.closeCustomAlert()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        let messageRedColor = UIColor.colorFrom(colorType: .redTitleAlert)
        let messageBlackColor = UIColor.colorFrom(colorType: .blackTitleAlert)
        
        // Set Labels Text Color
        descriptionLabel.textColor = messageBlackColor
        pointsLabel.textColor = messageBlackColor
        yesButtonLabel.textColor = messageBlackColor
        noButtonLabel.textColor = messageRedColor
        
        // Set values
        descriptionLabel.text = messageType.rawValue
        
        var image: UIImage? = UIImage()
        switch messageType! {
        case .goalDeleted:
            image = UIImage(named: "goal_deleted")
        case .actionDeleted:
            image = UIImage(named: "action_deleted")
        default:
            alertImageView.removeFromSuperview()
            return
        }
        alertImageView.image = image
    }
}
