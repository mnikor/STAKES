//
//  SSFourthOnboardingViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSFourthOnboardingViewController: SSBaseViewController {
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightActionButton.setImage(UIImage(named: "arrow"), for: .normal)
        rightActionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.ssStoryboard(type: .home).ssInstantiateViewController(type: .mainNC)
        rightActionButton.removeFromSuperview()
    }
}