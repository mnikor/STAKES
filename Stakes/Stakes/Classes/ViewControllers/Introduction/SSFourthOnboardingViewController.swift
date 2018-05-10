//
//  SSFourthOnboardingViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSFourthOnboardingViewController: SSBaseViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tipLabel: SSBaseLabel!
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let opacityDefaultColor = UIColor.colorFrom(colorType: .defaultBlack).withAlphaComponent(0.5)
        tipLabel.textColor = opacityDefaultColor
    }
}
