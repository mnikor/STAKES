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
        
        createGoalView.goalNameTextField.text = createGoalView.goalNameTextField.placeholder
    }
}
