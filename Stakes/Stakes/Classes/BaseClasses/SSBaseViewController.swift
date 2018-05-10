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
    var rightActionButton: SSRightActionButton!
    let points = SSPoint()
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsNavigationController()
        rightActionButton = SSRightActionButton(viewFrame: view.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set image for Side Menu Left Bar Button
        self.addLeftBarButtonWithImage(getLeftBarButtonImage())
        self.navigationItem.leftBarButtonItem?.tintColor = .darkGray
        
        // Update Points Label
        self.pointChanged(withAnimation: false)
    }
    
    
    // MARK: Public funcs
    func setTitle(_ newTitle: String) {
        
        let title = SSBaseLabel()
        title.text = newTitle
        title.textColor = UIColor.colorFrom(colorType: .defaultBlack)
        navigationItem.titleView = title
    }
    
    // Image for Side Menu Left Bar Button
    func getLeftBarButtonImage() -> UIImage {
        return UIImage(named: "menu_button")!.withRenderingMode(.alwaysTemplate)
    }
    
    // Create Background view with Circles
    func createCirclesBackground() {
        
        let circleView = UIImageView(image: UIImage(named: "background"))
        circleView.frame = self.view.frame
        view.insertSubview(circleView, at: 0)
    }
    
    // Hiding Keyboard When Tapped Around
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Action for hideKeyboardWhenTappedAround func
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: Private funcs
    
    // Settings for Navigaton Controller
    private func settingsNavigationController() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        navBar.tintColor = UIColor.fromRGB(rgbValue: 0x686868)
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        // Add Right UIBarButtonItem
        let rightButton = UIBarButtonItem(customView: SSPointsView())
        navigationItem.rightBarButtonItem = rightButton
    }
}


// MARK: SSPointChangeValueDelegate
extension SSBaseViewController: SSPointChangeValueDelegate {
    
    func pointChanged(withAnimation: Bool) {
        if let pointsView = navigationItem.rightBarButtonItem?.customView as? SSPointsView {
            pointsView.updatePointsView(withCounting: withAnimation)
        }
    }
}

