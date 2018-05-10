//
//  SSLevelsOfMasteryViewController.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 3/12/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit

class SSLevelsOfMasteryViewController: SSBaseViewController {
    
    
    // MARK: - Public Properties
    var currentLevel: Level!
    
    
    // MARK:  - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoButton: UIButton!
    
    
    // MARK: - Private Properties
    private var tableViewControl: TableViewControl!
    private var levels: [Level] {
        return SSLevelsManager.instance.levels
    }
    
    
    // MARK:  - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init TableControl
        tableViewControl = TableViewControl(tableView: tableView, cellID: SSLevelsTableViewCell.reuseID)
        tableViewControl.sections = [Section(dataSource: levels)]
        tableView.reloadData()
        self.setTitle("Levels of Mastery")
        settingsUI()
        checkNewLevel()
    }
    
    
    // MARK:  - Actions
    @IBAction func tappedInfoButton(_ sender: UIButton) {
        SSMessageManager.showCustomAlertWith(message: .levelsInfo, onViewController: self)
    }
    
    
    // MARK: - Private funcs
    private func settingsUI() {
        
        // TableView
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        // For small iPhone's screens
        if tableView.frame.height + 100 < view.frame.height {
            tableView.isScrollEnabled = false
        }
    }
    
    private func checkNewLevel() {
        
        // Alert when new Level achieved
        let key = SSConstants.keys.kCurrentLevelType.rawValue
        let userDefaults = UserDefaults.standard
        if let currentLevelType = userDefaults.string(forKey: key) {
            if currentLevelType != currentLevel.type.rawValue {
                SSMessageManager.showCustomAlertWith(message: .masteryLevel, onViewController: self)
                userDefaults.set(currentLevel.type.rawValue, forKey: key)
            }
        }
    }
}
