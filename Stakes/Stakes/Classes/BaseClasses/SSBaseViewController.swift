//
//  SSBaseViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSBaseViewController: UIViewController {
    
    
    // MARK: Public Properties
    lazy var rightActionButton: SSRightActionButton = {
        return SSRightActionButton(viewFrame: view.frame)
    }()
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    // MARK: Private funcs
    
    // Hiding Keyboard When Tapped Around
    private func hideKeyboardWhenTappedAround() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Action for hideKeyboardWhenTappedAround func
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
