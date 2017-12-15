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
    
    
    // MARK: Private Properties
    private let nibName = "SSShareGoalAlertView"
    
    
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
    
    @IBAction func tappedFBButton(_ sender: UIButton) {
        delegate?.actionCustomAlert(actionType: .shareFB)
    }
    
    @IBAction func tappedGoogleButton(_ sender: SSBaseButton) {
        delegate?.actionCustomAlert(actionType: .shareGoogle)
    }
    
    @IBAction func tappedTwitterButton(_ sender: UIButton) {
        delegate?.actionCustomAlert(actionType: .shareTwitter)
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
        
        let titleViewColor = UIColor.colorFrom(colorType: .light).withAlphaComponent(0.21)
        let messageBlackColor = UIColor.colorFrom(colorType: .blackTitleAlert)
        
        // Set Labels Text Color
        titleLabel.textColor = messageBlackColor
        pointsLabel.textColor = messageBlackColor
        titleView.backgroundColor = titleViewColor
    }
}
