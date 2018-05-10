//
//  SSFeedbackViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit


class SSFeedbackViewController: SSBaseViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var rateButton: SSCenterActionButton!
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCirclesBackground()
        hideKeyboardWhenTappedAround()
    }
    
    override func createCirclesBackground() {
        let circleView = UIImageView(image: UIImage(named: "background_feedback"))
        circleView.frame = self.view.frame
        view.insertSubview(circleView, at: 0)
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedStarsButton(_ sender: UIButton) {
        FeedbackHepler.rateApp(appStoreLink: SSConstants.appStoreLink)
    }
    
    @IBAction func tappedRateButton(_ sender: SSCenterActionButton) {
        FeedbackHepler.rateApp(appStoreLink: SSConstants.appStoreLink)
    }
}
