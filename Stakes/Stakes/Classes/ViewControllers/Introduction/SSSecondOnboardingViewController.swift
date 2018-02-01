//
//  SSSecondOnboardingViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSSecondOnboardingViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var createGoalView: SSCreateGoalView!
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGoalView.goalNameTextField.text = "Run a Marathon"
        createGoalView.goalUnderlineView.backgroundColor = UIColor.colorFrom(colorType: .defaultBlack)
        createGoalView.goalNameTextView.isHidden = true
        
        createGoalView.dueDateTextField.text = "September 10th, 2018"
        createGoalView.dueDateTextField.textColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createGoalView.dueDateTextField.resizeFont()
    }
}
