//
//  SSThirdOnboardingViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/9/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit

class SSThirdOnboardingViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var timeLineView: UIView!
    @IBOutlet weak var descriptionLabel: SSBaseLabel!
    
    
    // MARK: Private Properties
    private var timeLineViewOriginY = CGFloat()
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.sizeByTextFor(lines: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timeLineViewOriginY = timeLineView.frame.origin.y
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timeLineView.frame.origin.y = view.frame.height
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            
            self?.timeLineView.frame.origin.y = self?.timeLineViewOriginY ?? 359.5
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            
            self?.timeLineView.frame.origin.y = self?.view.frame.height ?? 900.0
        })
    }
}
