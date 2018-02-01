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
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var yesButtonLabel: SSBaseLabel!
    @IBOutlet weak var noButtonLabel: SSBaseLabel!
    @IBOutlet weak var pointsLabel: SSBaseLabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var starImageView: UIImageView!
    
    
    // MARK: Private Properties
    private let nibName = "SSActionAlertView"
    
    
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
    
    @IBAction func tappedYesButton(_ sender: SSBaseButton) {
        delegate?.actionCustomAlert!()
    }
    
    @IBAction func tappedNoButton(_ sender: SSBaseButton) {
        self.delegate?.closeCustomAlert()
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
        descriptionLabel.textColor = messageBlackColor
        pointsLabel.textColor = messageBlackColor
        yesButtonLabel.textColor = messageBlackColor
        noButtonLabel.textColor = messageRedColor
    }
}
