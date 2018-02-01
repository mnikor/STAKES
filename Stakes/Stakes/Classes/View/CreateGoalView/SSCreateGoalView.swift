//
//  SSCreateGoalView.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/24/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSCreateGoalView: UIView {
    
    
    // MARK: Outlets
    @IBOutlet weak var goalNameTextView: SSNameTextView!
    @IBOutlet weak var goalNameTextField: SSGoalTextField!
    @IBOutlet weak var dueDateTextField: SSDueDateTextField!
    @IBOutlet weak var goalUnderlineView: SSUnderlineView!
    @IBOutlet weak var dueDateUnderlineView: SSUnderlineView!
    @IBOutlet weak var contentView: UIView!
    
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    
    // MARK: Private funcs
    private func xibSetup() {
        
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        goalNameTextField.textColor = UIColor.colorFrom(colorType: .defaultBlack)
        dueDateTextField.textColor = UIColor.colorFrom(colorType: .defaultBlack)
        
        goalNameTextView.charactersLimit = 65
        goalNameTextView.linesLimit = 0
        addSubview(contentView!)
    }
    
    private func loadViewFromNib() -> UIView! {
        
        let nib = UINib(nibName: "SSCreateGoalView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
