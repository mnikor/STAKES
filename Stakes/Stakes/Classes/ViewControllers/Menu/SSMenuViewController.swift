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
    
    
    // MARK: Private Properties
    private var sideMenu: SlideMenuController!
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = UIApplication.shared.keyWindow?.rootViewController as! SlideMenuController
        settingsUI()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var viewController = sideMenu.mainViewController!
        let homeVC = SSHomeViewController.instantiate(.home) as! SSHomeViewController
        
        switch indexPath.row {
            
        // Active Goals
        case 0: viewController = homeVC
            
        // Achieved Goals
        case 1:
            
            homeVC.filteredGoalBy(.complete)
            viewController = homeVC
            
        // Settings
        case 2: viewController = SSSettingsViewController.instantiate(.menu)
            
        // Feedback
        case 3: viewController = SSFeedbackViewController.instantiate(.menu)
        default: break
        }
        
        let navigation = UINavigationController(rootViewController: viewController)
        sideMenu.changeMainViewController(navigation, close: true)
    }
    
    
    // MARK: Action funcs
    @IBAction func tappedMenuButton(_ sender: UIButton) {
        
        sideMenu.closeLeft()
    }
    
    
    // MARK: Private funcs
    private func settingsUI() {
        
        tableView.tableFooterView = UIView()
    }
}
