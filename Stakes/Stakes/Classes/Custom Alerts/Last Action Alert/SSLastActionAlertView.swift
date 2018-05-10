//
//  SSLastActionAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/27/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSLastActionAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var noButtonLabel: SSBaseLabel!
    @IBOutlet weak var contentView: UIView!
    
    
    // MARK: Public Properties
    var goal: Goal?
    
    
    // MARK: Private Properties
    private let lastActionText = SSMessageManager.MessageTypeDescription.lastAction.rawValue
    private var isLastActionView: Bool {
        return descriptionLabel.text! == lastActionText
    }
    
    
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
    }
    
    
    // MARK: Actions funcs
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.closeCustomAlert()
    }
    
    @IBAction func tappedYesButton(_ sender: UIButton) {
        
        self.delegate?.closeCustomAlert()
        if isLastActionView {
            
            goal?.changeStatus(.complete)
            SSMessageManager.showCustomAlertWith(message: .goalAchieved, goal: goal, onViewController: nil)
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getSlideMenuController()
            
        } else {
            
            delegate?.actionCustomAlert!()
        }
    }
    
    @IBAction func tappedNoButton(_ sender: UIButton) {
        
        if isLastActionView {
            
            descriptionLabel.text = SSMessageManager.MessageTypeDescription.lastActionNoSelected.rawValue
            
        } else {
            
            self.delegate?.closeCustomAlert()
            
        }
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        let messageRedColor = UIColor.colorFrom(colorType: .redTitleAlert)
        let messageBlackColor = UIColor.colorFrom(colorType: .blackTitleAlert)
        
        // Set Labels Text Color
        noButtonLabel.textColor = messageRedColor
        descriptionLabel.textColor = messageBlackColor
        
        // Set values
        descriptionLabel.text = lastActionText
    }
}
