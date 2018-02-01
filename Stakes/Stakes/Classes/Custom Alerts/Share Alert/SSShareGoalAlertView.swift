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
    @IBOutlet weak var earnLabel: SSBaseLabel!
    
    
    // MARK: Private Properties
    private let nibName = "SSShareGoalAlertView"
    private let height:CGFloat = 120.0
    private let width:CGFloat = 294.0
    
    private var customFrame:CGRect {
        return CGRect(x: (UIWindow().frame.width / 2.0) - (width / 2.0),
                      y: 20.0,
                      width: width,
                      height: height)
    }
    
    
    // MARK: Initializers
    init() {
        super.init(frame: customFrame)
        xibSetup()
    }
    
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
        
        let titleViewColor = UIColor.colorFrom(colorType: .light).withAlphaComponent(0.21)
        let messageBlackColor = UIColor.colorFrom(colorType: .blackTitleAlert)
        
        // UI of View
        self.makeBorder(width: .small, color: UIColor.colorFrom(colorType: .red))
        self.layer.cornerRadius = 8.0
        self.backgroundColor = .white
        
        // Set Labels Text Color
        titleLabel.textColor = messageBlackColor
        pointsLabel.textColor = messageBlackColor
        earnLabel.textColor = UIColor.colorFrom(colorType: .blue)
        titleView.backgroundColor = titleViewColor
        
        // Set values
        titleLabel.text = SSMessageManager.MessageTypeDescription.share.rawValue
        pointsLabel.text = "+10"
    }
}
