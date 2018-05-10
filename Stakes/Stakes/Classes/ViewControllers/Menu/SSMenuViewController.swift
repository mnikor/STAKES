//
//  SSMenuViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/10/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SSMenuViewController: UITableViewController {
    
    
    // MARK: - Private Properties
    private var currentLevel: Level!
    private var sideMenu: SlideMenuController!
    
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sideMenu = UIApplication.shared.keyWindow?.rootViewController as! SlideMenuController
        
        // Check User Level
        self.currentLevel = SSLevelsManager.instance.getCurrentLevel()
        settingsUI()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var viewController = sideMenu.mainViewController!
        let homeVC = SSHomeViewController.instantiate(.home) as! SSHomeViewController
        
        switch indexPath.row {
            
        // Active Goals
        case 0:
            homeVC.controllerType = .active
            viewController = homeVC
            
        // Achieved Goals
        case 1:
            
            homeVC.filteredGoalBy(.complete)
            homeVC.controllerType = .archived
            viewController = homeVC
            
        // Lessons
        case 2: viewController = SSLessonsViewController.instantiate(.menu)
            
        // LEvels
        case 3: viewController = SSLevelsOfMasteryViewController.instantiate(.menu) as! SSLevelsOfMasteryViewController
        (viewController as! SSLevelsOfMasteryViewController).currentLevel = self.currentLevel
            
        // Settings
        case 4: viewController = SSSettingsViewController.instantiate(.menu)
        
        //Feedback
        case 5: viewController = SSFeedbackViewController.instantiate(.menu)
        default: break
        }
        
        let navigation = UINavigationController(rootViewController: viewController)
        sideMenu.changeMainViewController(navigation, close: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.model.hasPrefix("iPad") {
            return 35
        }
        return 54
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedMenuButton(_ sender: UIButton) {
        
        sideMenu.closeLeft()
    }
    
    @objc func tappedLevelsButton() {
        
        let levelsVC = SSLevelsOfMasteryViewController.instantiate(.menu) as! SSLevelsOfMasteryViewController
        levelsVC.currentLevel = self.currentLevel
        let navigation = UINavigationController(rootViewController: levelsVC)
        sideMenu.changeMainViewController(navigation, close: true)
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        makeLevelsButtonFor(self.currentLevel)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
    }
    
    // Make Levels Button
    private func makeLevelsButtonFor(_ level: Level) {
        
        let labelHeight: CGFloat = 12.0
        let buttonSize = CGSize(width: 90.0, height: 90.0)
        let buttonFrame = CGRect(origin: CGPoint(x: 0.0, y: view.frame.height - buttonSize.height - 20.0), size: buttonSize)
        let labelFrame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y - labelHeight, width: buttonFrame.width, height: labelHeight)
        
        let button = UIButton(frame: buttonFrame)
        let label = UILabel(frame: labelFrame)
        
        button.setImage(UIImage(named: level.image), for: .normal)
        button.addTarget(self, action: #selector(tappedLevelsButton), for: .touchUpInside)
        button.adjustsImageWhenHighlighted = false
        
        label.text = level.title
        label.textAlignment = .center
        label.font = UIFont(name: SSConstants.fontType.helveticaBold.rawValue, size: 9.0)
        label.textColor = UIColor.fromRGB(rgbValue: 0x444444)
        
        view.addSubview(button)
        view.addSubview(label)
    }
}
