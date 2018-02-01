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
    
    
    // MARK: Public Properties
    var goal: Goal?
    
    
    // MARK: Private Properties
    private let nibName = "SSLastActionAlertView"
    private let lastActionText = SSMessageManager.MessageTypeDescription.lastAction.rawValue
    private var isLastActionView: Bool {
        return descriptionLabel.text! == lastActionText
    }
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    
    // MARK: Actions funcs
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        self.delegate?.closeCustomAlert()
    }
    
    @IBAction func tappedYesButton(_ sender: UIButton) {
        
        self.delegate?.closeCustomAlert()
        if isLastActionView {
            
            goal?.changeStatus(.complete)
            SSMessageManager.showCustomAlertWith(message: .goalAchieved, onViewController: nil)
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
    
    // Load Xib
    private func xibSetup() {
        
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        settingsUI()
    }
    
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
