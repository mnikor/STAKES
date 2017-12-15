//
//  SSComlpeteActionAlertView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 12/12/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSComlpeteActionAlertView: SSBaseCustomAlertView {
    
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: SSBaseLabel!
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    @IBOutlet weak var bottomLabel: SSBaseLabel!
    
    
    // MARK: Private Properties
    private let nibName = "SSComlpeteActionAlertView"
    
    
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
        titleLabel.textColor = messageRedColor
        descriptionLabel.textColor = messageBlackColor
        bottomLabel.textColor = messageRedColor
    }
}
