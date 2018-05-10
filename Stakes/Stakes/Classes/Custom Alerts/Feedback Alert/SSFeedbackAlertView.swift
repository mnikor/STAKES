//
//  SSFeedbackAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/7/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSFeedbackAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.loadFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bounds = contentView.bounds
    }
    
    
    // MARK: Actions funcs
    @IBAction func tappedCloseAlertButton(_ sender: UIButton) {
        UserDefaults.standard.set(0, forKey: SSConstants.keys.kCompletedActions.rawValue)
        self.delegate?.closeCustomAlert()
    }
    
    @IBAction func tappedRateButton(_ sender: UIButton) {
        FeedbackHepler.rateApp(appStoreLink: SSConstants.appStoreLink)
    }
    
    @IBAction func tappedSendFeedbackButton(_ sender: UIButton) {
        
        for view in contentView.subviews {
            view.isHidden = true
        }
        self.closeButton.isHidden = false
        
        let feedbackView = SSFeedbackView(frame: self.contentView.bounds)
        self.contentView.addSubview(feedbackView)
    }
    
    @IBAction func tappedRemindLaterButton(_ sender: UIButton) {
        UserDefaults.standard.set(0, forKey: SSConstants.keys.kCompletedActions.rawValue)
        self.delegate?.closeCustomAlert()
    }
}
